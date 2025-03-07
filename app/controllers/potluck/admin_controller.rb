module Potluck
  class AdminController < ApplicationController
    before_action :set_event
    before_action :verify_admin_token
    
    def show
      # This is the main admin dashboard for a specific event
      @items = @event.items.includes(:signups)
      @signups = @event.signups.includes(:potluck_item).order(created_at: :desc)
    end
    
    def toggle_notifications
      @event.toggle_notifications!
      redirect_to admin_potluck_event_path(@event, token: @event.admin_uuid), 
                  notice: "Email notifications have been #{@event.email_notifications ? 'enabled' : 'disabled'}."
    end
    
    def message_participant
      participant_email = params[:email]
      message = params[:message]
      
      if participant_email.present? && message.present?
        @event.message_participant(participant_email, message)
        redirect_to admin_potluck_event_path(@event, token: @event.admin_uuid), 
                    notice: "Your message has been sent to #{participant_email}."
      else
        redirect_to admin_potluck_event_path(@event, token: @event.admin_uuid), 
                    alert: "Please provide both an email address and a message."
      end
    end
    
    private
    
    def set_event
      @event = Potluck::Event.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to potluck_events_path, alert: "Potluck event not found."
    end
    
    def verify_admin_token
      unless params[:token].present? && params[:token] == @event.admin_uuid
        redirect_to potluck_events_path, alert: "You don't have permission to access this page."
      end
    end
  end
end
