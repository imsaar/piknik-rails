class EventsController < ApplicationController
  def new
    @event = Event.new
  end

  def create
    @event = Event.new(event_params)
    
    if @event.save
      redirect_to @event, notice: 'Your Piknik event was successfully created!'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @event = Event.find_by(id: params[:id])
    
    if @event.nil?
      redirect_to root_path, alert: 'Event not found'
    end
  end

  def join
    # This action will display a form to enter an event code
  end

  def attend
    # This action will process the event code and redirect to the event
    @event = Event.find_by(code: params[:code])
    
    if @event
      redirect_to @event
    else
      redirect_to join_event_path, alert: 'Invalid event code. Please try again.'
    end
  end

  private

  def event_params
    params.require(:event).permit(:name, :description, :date, :location, :code)
  end
end
