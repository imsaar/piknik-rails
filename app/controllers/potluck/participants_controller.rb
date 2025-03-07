module Potluck
  class ParticipantsController < ApplicationController
    before_action :set_event
    
    def show
      # This is the main participant view for a specific event
      @items = @event.items.includes(:signups)
    end
    
    private
    
    def set_event
      @event = Potluck::Event.find_by_participant_token(params[:token])
      
      unless @event
        redirect_to root_path, alert: "Potluck event not found. Please check your link and try again."
      end
    end
  end
end
