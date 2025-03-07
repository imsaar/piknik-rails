class DishesController < ApplicationController
  before_action :set_event
  before_action :set_dish, only: [:edit, :update, :destroy]
  
  def create
    @dish = @event.dishes.build(dish_params)
    
    if @dish.save
      redirect_to @event, notice: "#{@dish.name} was successfully added to your potluck."
    else
      flash[:alert] = @dish.errors.full_messages.to_sentence
      redirect_to @event
    end
  end

  def edit
    # The view will be rendered
  end

  def update
    if @dish.update(dish_params)
      redirect_to @event, notice: "#{@dish.name} was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    dish_name = @dish.name
    @dish.destroy
    
    redirect_to @event, notice: "#{dish_name} was successfully removed from your potluck."
  end
  
  private
  
  def set_event
    @event = Event.find(params[:event_id])
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: "Event not found."
  end
  
  def set_dish
    @dish = @event.dishes.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to @event, alert: "Dish not found."
  end
  
  def dish_params
    params.require(:dish).permit(:name, :description, :quantity_needed)
  end
end
