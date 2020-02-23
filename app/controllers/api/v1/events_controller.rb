class Api::V1::EventsController < ApplicationController

  # All records
  def index
    events = Event.all.order(name: :asc)
  
    # Render json
    render json: { events: events }
  end

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

end
