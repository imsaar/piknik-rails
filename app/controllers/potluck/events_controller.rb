module Potluck
  class EventsController < ApplicationController
    before_action :set_event, only: [:show, :edit, :update, :destroy]
    
    def index
      # This could be a landing page for the potluck system
      @events = Potluck::Event.upcoming.order(event_date: :asc)
    end
    
    def show
      # If no event is found, redirect to the new action
      redirect_to new_potluck_event_path unless @event
    end
    
    def new
      @event = Potluck::Event.new
    end
    
    def create
      @event = Potluck::Event.new(event_params)
      
      if @event.save
        # Send the admin to the admin page for their event
        redirect_to admin_potluck_event_path(@event, token: @event.admin_uuid), 
                    notice: 'Your potluck has been created. An email with the admin link has been sent to your email address.'
      else
        render :new, status: :unprocessable_entity
      end
    end
    
    def edit
      # Ensure this event can be edited
      redirect_to potluck_events_path, alert: 'This event cannot be edited.' unless @event&.editable?
    end
    
    def update
      if @event.update(event_params)
        redirect_to admin_potluck_event_path(@event, token: @event.admin_uuid), 
                    notice: 'Potluck was successfully updated.'
      else
        render :edit, status: :unprocessable_entity
      end
    end
    
    def destroy
      @event.destroy
      redirect_to potluck_events_path, notice: 'Potluck was successfully deleted.'
    end
    
    private
    
    def set_event
      # Try to find the event by ID, or nil if not found
      @event = Potluck::Event.find_by(id: params[:id])
    end
    
    def event_params
      params.require(:potluck_event).permit(:name, :event_date, :theme, :admin_email, :admin_name)
    end
  end
end
