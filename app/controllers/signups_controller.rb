class SignupsController < ApplicationController
  before_action :set_dish, only: [:create]
  
  def new
    @dish = Dish.find(params[:dish_id])
    @signup = Signup.new
    @event = @dish.event
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: "Dish not found."
  end
  
  def create
    # Create a signup from parameters
    @signup = @dish.signups.build(
      participant_name: params[:signup] ? params[:signup][:participant_name] : params[:participant_name],
      participant_email: params[:signup] ? params[:signup][:participant_email] : params[:participant_email],
      quantity: params[:signup] ? params[:signup][:quantity] : params[:quantity]
    )
    
    if @signup.save
      redirect_to @dish.event, notice: "You have successfully signed up to bring #{@dish.name}!"
    else
      flash[:alert] = @signup.errors.full_messages.to_sentence
      redirect_to @dish.event
    end
  end
  
  private
  
  def set_dish
    @dish = Dish.find(params[:dish_id])
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: "Dish not found."
  end
  
  def signup_params
    if params[:signup].present?
      params.require(:signup).permit(:participant_name, :participant_email, :quantity)
    else
      params.permit(:participant_name, :participant_email, :quantity)
    end
  end
end
