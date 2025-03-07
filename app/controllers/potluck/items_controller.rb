module Potluck
  class ItemsController < ApplicationController
    before_action :set_event
    before_action :verify_admin_token
    before_action :set_item, only: [:edit, :update, :destroy, :update_quantity]
    
    def new
      @item = @event.items.build
    end
    
    def create
      @item = @event.items.build(item_params)
      
      if @item.save
        redirect_to admin_potluck_event_path(@event, token: @event.admin_uuid), 
                    notice: "#{@item.name} was successfully added to your potluck."
      else
        render :new, status: :unprocessable_entity
      end
    end
    
    def edit
    end
    
    def update
      if @item.update(item_params)
        redirect_to admin_potluck_event_path(@event, token: @event.admin_uuid), 
                    notice: "#{@item.name} was successfully updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end
    
    def destroy
      item_name = @item.name
      @item.destroy
      
      redirect_to admin_potluck_event_path(@event, token: @event.admin_uuid), 
                  notice: "#{item_name} was successfully removed from your potluck."
    end
    
    def update_quantity
      quantity = params[:quantity].to_i
      
      if quantity > 0 && @item.update(quantity_needed: quantity)
        redirect_to admin_potluck_event_path(@event, token: @event.admin_uuid), 
                    notice: "Quantity for #{@item.name} was updated to #{quantity}."
      else
        redirect_to admin_potluck_event_path(@event, token: @event.admin_uuid), 
                    alert: "Please enter a valid quantity greater than 0."
      end
    end
    
    private
    
    def set_event
      @event = Potluck::Event.find(params[:event_id])
    rescue ActiveRecord::RecordNotFound
      redirect_to potluck_events_path, alert: "Potluck event not found."
    end
    
    def set_item
      @item = @event.items.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to admin_potluck_event_path(@event, token: @event.admin_uuid), 
                  alert: "Item not found."
    end
    
    def verify_admin_token
      unless params[:token].present? && params[:token] == @event.admin_uuid
        redirect_to potluck_events_path, alert: "You don't have permission to access this page."
      end
    end
    
    def item_params
      params.require(:potluck_item).permit(:name, :quantity_needed, :description)
    end
  end
end
