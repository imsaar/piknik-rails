class EventsController < ApplicationController
  def new
    @event = Event.new
  end

  def create
    @event = Event.new(event_params)
    
    if @event.save
      # Track that this user created this event
      session[:created_event_ids] ||= []
      session[:created_event_ids] << @event.id.to_s
      
      redirect_to @event, notice: 'Your Piknik event was successfully created!'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @event = Event.find_by(id: params[:id])
    
    if @event.nil?
      redirect_to root_path, alert: 'Event not found'
      return
    end
    
    # Load dishes for this event to display in admin and participant sections
    @dishes = @event.dishes.includes(:signups) if @event.respond_to?(:dishes)
    
    # Check if the current user is the event creator (admin)
    # In a real app with authentication, you would compare current_user.id with @event.user_id
    # For simplicity, we'll use a session-based approach
    @is_admin = session[:created_event_ids].present? && session[:created_event_ids].include?(@event.id.to_s)
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
    params.require(:event).permit(:name, :description, :date, :location, :code, :theme)
  end
end
