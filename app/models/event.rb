class Event < ApplicationRecord
  # Associations
  has_many :dishes, dependent: :destroy
  
  # Validations
  validates :name, presence: true
  validates :date, presence: true
  validates :location, presence: true
  validates :code, uniqueness: true, allow_blank: true
  
  # Callbacks
  before_create :generate_event_code
  
  private
  
  # Generate a unique 6-character alphanumeric code for the event
  def generate_event_code
    return if code.present?
    
    loop do
      # Generate a random 6-character alphanumeric code
      self.code = SecureRandom.alphanumeric(6).upcase
      break unless Event.exists?(code: code)
    end
  end
end
