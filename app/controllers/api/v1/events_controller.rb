require 'google/api_client/client_secrets.rb'
require 'google/apis/calendar_v3'

class Api::V1::EventsController < ApplicationController

  def index
    authenticate
    # render json: { message: "Welcome Home!" }

    # Initialize Google Calendar API
    service = Google::Apis::CalendarV3::CalendarService.new
    # Use google keys to authorize
    service.authorization = google_secret.to_authorization
    # Request for a new aceess token just incase it expired
    service.authorization.refresh!

    # Request new token if expired
    # if token.expired?
    #   new_access_token = service.authorization.refresh!
    #   token.access_token = new_access_token['access_token']
    #   token.expires_at = Time.now.to_i + new_access_token['expires_in'].to_i
    #   token.save
    # end

    # Get a list of calendars
    # calendar_list = service.list_calendar_lists.items
    
    #   calendar_list.select do |calendar|
    #     calendar.summary.include?("TripIt")
    #   end

  # binding.pry


  # calendar_id = "primary"
  # calendar_id = "30lf4jpge026voaudmi6fdg49eulo5uv@import.calendar.google.com"
  calendar_id = "aaron@webmeadow.com"
  response = service.list_events(
    calendar_id,
    max_results: 1000,
    single_events: true,
    order_by: "startTime",
    time_min: DateTime.now.rfc3339
  )

  # Get all events
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

  
  # Convert into hash
  test_hash = JSON.parse(response.to_json)
  
  # Get locations with a comma
  location_hash = test_hash["items"].select{|event| event["location"] && event["location"].include?(",")}

  binding.pry

  # location_names = location_hash.each{|e| puts e["summary"] +" - "+ e["location"]}
  # Output: 
  # Boston Trip - Boston, MA
  # Minneapolis Trip - Minneapolis, MN
  # Austin Trip - Austin, TX
  # Portland Trip - Portland, OR
  # Virginia Trip - Falls Church, VA


  # Add hash of near parks for each location


  # puts "Upcoming events:"
  # puts "No upcoming events found" if response.items.empty?
  # response.items.each do |event|
  #   start = event.start.date || event.start.date_time
  #   puts "- #{event.summary} (#{start})"
  # end

  render json: { eventList: location_hash }
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
    event = event.new(event_params)
    if event.save
      # Render json
      render json: {event: event}
    else
      resource_error
    end
  end

  # Update record
  def update
    event = event.find(params[:id])
    event.update(event_params)

    if event.save
      # Render json
      render json: {event: event}
    else
      resource_error
    end
  end

  # Delete record
  def destroy
    event = event.find(params[:id])
    
    # Only event owner can delete
    authorize_resource(event)
    event.destroy

    # Render json
    render json: { event: event.id}
  end


  private

  def event_params
    params.require(:event).permit(:name)
  end

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
  
end
