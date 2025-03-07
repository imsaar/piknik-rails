class Dish < ApplicationRecord
  # Associations
  belongs_to :event
  has_many :signups, dependent: :destroy
  
  # Validations
  validates :name, presence: true
  validates :quantity_needed, presence: true, numericality: { greater_than: 0 }
  
  # Set default values
  after_initialize :set_defaults, if: :new_record?
  
  # Scopes
  scope :available, -> { where('quantity_needed > quantity_signed_up OR quantity_signed_up IS NULL') }
  scope :filled, -> { where('quantity_needed <= quantity_signed_up') }
  
  # Methods
  def available_quantity
    signed_up = quantity_signed_up || 0
    [quantity_needed - signed_up, 0].max
  end
  
  def fully_signed_up?
    signed_up = quantity_signed_up || 0
    signed_up >= quantity_needed
  end
  
  def available_for_signup?(requested_quantity)
    available_quantity >= requested_quantity
  end
  
  private
  
  def set_defaults
    self.quantity_signed_up ||= 0
  end
end
