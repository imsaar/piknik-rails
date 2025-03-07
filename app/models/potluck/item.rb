class Potluck::Item < ApplicationRecord
  # Associations
  belongs_to :potluck_event
  has_many :signups, class_name: 'Potluck::Signup', foreign_key: 'potluck_item_id', dependent: :destroy
  
  # Validations
  validates :name, presence: true
  validates :quantity_needed, presence: true, numericality: { greater_than: 0 }
  
  # Scopes
  scope :available, -> { where('quantity_needed > quantity_signed_up') }
  scope :filled, -> { where('quantity_needed <= quantity_signed_up') }
  
  # Methods
  def available_quantity
    [quantity_needed - quantity_signed_up, 0].max
  end
  
  def fully_signed_up?
    quantity_signed_up >= quantity_needed
  end
  
  def update_signed_up_quantity
    # Calculate the sum of confirmed signup quantities
    confirmed_quantity = signups.confirmed.sum(:quantity)
    update(quantity_signed_up: confirmed_quantity)
  end
  
  def confirmed_signups
    signups.confirmed
  end
  
  def pending_signups
    signups.unconfirmed
  end
  
  def available_for_signup?(requested_quantity)
    available_quantity >= requested_quantity
  end
end
