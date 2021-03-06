require 'google/api_client/client_secrets.rb'
require 'google/apis/calendar_v3'
require 'active_support'

class Api::V1::EventsController < ApplicationController
  before_action :authenticate

  # All events
  def index
    # Only keep locations that have comma (indicates city, state)
    location_hash = get_google_events["items"].select{|event| event["location"] && event["location"].include?(",") && event["location"].exclude?("http") && event["summary"].exclude?("[id:")}

    ### Sample output
    # location_names = location_hash.each{|e| puts e["summary"] +" - "+ e["location"]}
    # Output: 
    # Boston Trip - Boston, MA
    # Minneapolis Trip - Minneapolis, MN
    # Austin Trip - Austin, TX
    # Portland Trip - Portland, OR
    # Virginia Trip - Falls Church, VA

    ### Sample geocode usage
    # g = Geocoder.search("Boston, MA")
    # g.first.coordinates 
    # => [42.3602534, -71.0582912]

    # Add array of near parks (within 100 miles) to each location
    events_and_parks = location_hash.each{|event| event["nearParks"]= Park.near(event["location"], 100).as_json}

    # Get all events saved in database (parkEvents)
    park_events = Event.all.order(start_time: :asc)

    # Return events with parks
    render json: { googleEvents: events_and_parks, parkEvents: park_events }
  end


  # All records
  # def index
  #   events = Event.all.order(name: :asc)
  
  #   # Render json
  #   render json: { events: events }
  # end

  # Display record
  def show
    event = Event.find_by(id: params[:id])

    if event
      # Render json
      render json: { event: event }
    else
      not_found
    end
  end

  # Create record
  def create

    # Add parkEvent identifier
    event_params[:summary] << " [id: #{event_params[:park_id]}]"

    event = current_user.events.build(event_params)

    # Testing
      # Set park
      # park = Park.find(1)

      # Set event hash
      # e_params = {
      #   summary: "Visit #{park.fullName}", 
      #   location: park.address, 
      #   description: "Explore park!\n\n----\n\nAbout the Park:\n#{park.description}",
      #   start_time: "2020-02-28T17:00:00", 
      #   end_time: "2020-02-28T21:00:00", 
      #   timezone: "America/Los_Angeles", 
      #   park_id: park.id
      # }

      # Create event
      # event = current_user.events.build(e_params)

    # If event can save, also send to Google Calendar
    if event.save

      # Start Google calendar
      calendar = start_google_service

      # Format event for Google
      g_event = format_google_event(event)

      ### Future: Add error handling

      result = calendar.insert_event('primary', g_event)
      # puts "Event created: #{result.html_link}"

      event.g_cal_id = result.id
      event.save

      ### Future: Add attendee emails to array
      # g_attendees = event.attendees.map {|attendee| attendee = Google::Apis::CalendarV3::EventAttendee.new(email: attendee.email)}
      # Add to g_event: attendees: g_attendees

      # Render json
      render json: {event: event}
    else
      resource_error
    end
  end

  # Update record
  def update
    # event = Event.find(params[:id])
    # event.update(event_params)

binding.pry

  ### Test params
      park = Park.find(3)

      # Set test event hash
      e_params = {
        summary: "Visit #{park.fullName}", 
        location: park.address, 
        park_id: park.id
      }

      # Create event
      event = Event.find(22)
      event.update(e_params)

    # If event can save, also send to Google Calendar
    if event.save

      # Start Google calendar
      calendar = start_google_service

      # Format event for Google
      g_event = format_google_event(event)

      result = calendar.update_event('primary', event.g_cal_id, g_event)
      ### Add error handling

      # # On success, save google calendar id to event
      # event.g_cal_id = result.id
      # event.save

      # Return json
      render json: {event: event}
    else
      resource_error
    end
  end

  # Delete record
  def destroy
    event = Event.find(params[:id])

    # Only event owner can delete
    authorize_resource(event)
    
    # Start Google calendar
    calendar = start_google_service

    # Delete Google event
    result = calendar.delete_event('primary', event.g_cal_id)

    # Delete database event
    event.destroy

    # Render json
    render json: { event: event.id}
  end


  private

  def event_params
    params.require(:event).permit(:summary, :location, :description, :start_time, :end_time, :timezone, :user_id, :park_id)
  end

  # Start and authorize new calendar service
  def start_google_service
    # Initialize Google Calendar API
    service = Google::Apis::CalendarV3::CalendarService.new
    # Use google keys to authorize
    service.authorization = google_secret.to_authorization
    # Request new access token in case it expired
    service.authorization.refresh!

    return service
  end

  # Tokens and client env variables
  def google_secret
    Google::APIClient::ClientSecrets.new(
      { "web" =>
        { "access_token" => current_user.google_token,
          "refresh_token" => current_user.google_refresh_token,
          "client_id" => ENV['GOOGLE_CLIENT_ID'],
          "client_secret" => ENV['GOOGLE_CLIENT_SECRET']
        }
      }
    )
  end

  # Return hash of google events
  def get_google_events
    calendar = start_google_service
    ### Improvement: only refresh if token expired. Idea:
    # Request new token if expired
    # if token.expired?
    #   new_access_token = service.authorization.refresh!
    #   token.access_token = new_access_token['access_token']
    #   token.expires_at = Time.now.to_i + new_access_token['expires_in'].to_i
    #   token.save
    # end

    ### Useful for setup
    ## Manual requst for calendar list
    # calendar_list = service.list_calendar_lists.items
    ## Search for specific calendar
    # calendar_list.select do |calendar|
    #   calendar.summary.include?("TripIt")
    # end

    # Set calendar
    # Primary is main account
    calendar_id = "primary"

    # Get up to 1000 events in calendar
    events = calendar.list_events(
      calendar_id,
      max_results: 1000,
      single_events: true,
      order_by: "startTime",
      time_min: DateTime.now.rfc3339
    )

    ### Old get all events
    # ** Goes on forever! **
    # items = service.fetch_all do |token|
    #   service.list_events(
    #     calendar_id,
    #     max_results: 30,
    #     single_events: true,
    #     order_by: 'startTime',
    #     time_min: DateTime.now.rfc3339,
    #     page_token: token
    #   )
    # end

    # Convert event list into hash
    return JSON.parse(events.to_json)
  end

  # Return event hash in Google-friendly format  
  def format_google_event(event)
    Google::Apis::CalendarV3::Event.new(
      summary: event.summary,
      location: event.location,
      description: event.description,
      start: Google::Apis::CalendarV3::EventDateTime.new(
        date_time: event.start_time,
        # time_zone: event.timezone
      ),
      end: Google::Apis::CalendarV3::EventDateTime.new(
        date_time: event.end_time,
        # time_zone: event.timezone
      )
    )
  end


end