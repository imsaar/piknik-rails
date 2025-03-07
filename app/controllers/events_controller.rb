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
    # If the request comes with a code parameter, find the event by code
    if params[:code].present?
      @event = Event.find_by(code: params[:code])
    else
      @event = Event.find_by(id: params[:id])
    end
    
    if @event.nil?
      redirect_to root_path, alert: 'Event not found'
      return
    end
    
    # Load dishes for this event
    @dishes = @event.dishes.includes(:signups) if @event.respond_to?(:dishes)
    
    # Check if the current user is the event creator (admin)
    @is_admin = session[:created_event_ids].present? && session[:created_event_ids].include?(@event.id.to_s)
    
    # Redirect admin to admin view if they're at the base URL
    if @is_admin && request.path == event_path(@event)
      redirect_to admin_event_path(@event)
      return
    end
    
    # For non-admins or direct access via code, render the participant view
    render 'participate'
  end
  
  def admin
    @event = Event.find_by(id: params[:id])
    
    if @event.nil?
      redirect_to root_path, alert: 'Event not found'
      return
    end
    
    # Load dishes for this event
    @dishes = @event.dishes.includes(:signups) if @event.respond_to?(:dishes)
    
    # Verify admin access
    @is_admin = session[:created_event_ids].present? && session[:created_event_ids].include?(@event.id.to_s)
    
    unless @is_admin
      redirect_to participate_event_path(@event), alert: 'You do not have admin access to this event'
      return
    end
    
    render 'admin'
  end
  
  def participate
    @event = Event.find_by(id: params[:id])
    
    if @event.nil?
      redirect_to root_path, alert: 'Event not found'
      return
    end
    
    # Load dishes for this event
    @dishes = @event.dishes.includes(:signups) if @event.respond_to?(:dishes)
    
    # Always set to participant view
    @is_admin = false
    
    render 'participate'
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
