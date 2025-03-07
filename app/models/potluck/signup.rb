class Potluck::Signup < ApplicationRecord
  belongs_to :potluck_item
  
  # Validations
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :quantity, presence: true, numericality: { greater_than: 0 }
  validates :confirmation_token, uniqueness: true, allow_nil: true
  
  # Scopes
  scope :confirmed, -> { where(confirmed: true) }
  scope :unconfirmed, -> { where(confirmed: false) }
  
  # Callbacks
  before_create :generate_confirmation_token
  after_create :send_confirmation_email
  after_save :update_item_quantity
  after_destroy :decrement_item_quantity
  
  # Delegate event for convenience
  delegate :potluck_event, to: :potluck_item
  
  # Methods
  def confirm!
    update(confirmed: true)
    notify_admin_of_confirmation
  end
  
  def can_modify?
    # Can modify until 1 day before the event
    potluck_event.date > 1.day.from_now
  end
  
  def notify_admin_of_signup
    return unless potluck_event.email_notifications
    # Will implement mailer later
    # PotluckMailer.signup_notification(self).deliver_later
  end
  
  def notify_admin_of_confirmation
    return unless potluck_event.email_notifications
    # Will implement mailer later
    # PotluckMailer.confirmation_notification(self).deliver_later
  end
  
  private
  
  def generate_confirmation_token
    return if confirmation_token.present?
    
    loop do
      self.confirmation_token = SecureRandom.urlsafe_base64(16)
      break unless self.class.exists?(confirmation_token: confirmation_token)
    end
  end
  
  def send_confirmation_email
    # Will implement mailer later
    # PotluckMailer.signup_confirmation(self).deliver_later
  end
  
  def update_item_quantity
    if saved_change_to_quantity? || saved_change_to_confirmed?
      potluck_item.update_signed_up_quantity
    end
  end
  
  def decrement_item_quantity
    potluck_item.update_signed_up_quantity
  end
end
