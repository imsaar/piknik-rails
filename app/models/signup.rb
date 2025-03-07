class Signup < ApplicationRecord
  # Associations
  belongs_to :dish
  
  # Validations
  validates :participant_name, presence: true
  validates :participant_email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :quantity, presence: true, numericality: { greater_than: 0 }
  validate :dish_has_available_quantity
  
  # Callbacks
  after_initialize :set_defaults, if: :new_record?
  after_save :update_dish_quantity
  after_destroy :update_dish_quantity
  
  # Scopes
  scope :confirmed, -> { where(confirmed: true) }
  scope :unconfirmed, -> { where(confirmed: false) }
  
  # Delegates
  delegate :event, to: :dish
  
  private
  
  def set_defaults
    self.confirmed = false if confirmed.nil?
  end
  
  def dish_has_available_quantity
    return unless dish && quantity
    
    available = dish.available_quantity
    if new_record? && quantity > available
      errors.add(:quantity, "exceeds available amount. Only #{available} available.")
    elsif persisted? && quantity_changed? && quantity > (available + quantity_was)
      errors.add(:quantity, "exceeds available amount. Only #{available + quantity_was} available.")
    end
  end
  
  def update_dish_quantity
    # Update the dish's quantity_signed_up value
    total_quantity = dish.signups.sum(:quantity)
    dish.update_column(:quantity_signed_up, total_quantity)
  end
end
