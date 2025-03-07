class Potluck::Event < ApplicationRecord
  # Associations
  has_many :items, class_name: 'Potluck::Item', foreign_key: 'potluck_event_id', dependent: :destroy
  has_many :signups, through: :items
  
  # Validations
  validates :name, presence: true
  validates :event_date, presence: true
  validates :admin_email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :admin_uuid, presence: true, uniqueness: true
  validates :participant_uuid, presence: true, uniqueness: true
  
  # Aliases for better code readability
  alias_attribute :date, :event_date
  alias_attribute :email_notifications, :email_notifications
  
  # Callbacks
  before_validation :generate_uuids, on: :create
  after_create :send_admin_confirmation
  
  # Scopes
  scope :upcoming, -> { where('event_date > ?', Time.current) }
  scope :past, -> { where('event_date <= ?', Time.current) }
  
  # Class methods
  def self.find_by_admin_token(token)
    find_by(admin_uuid: token)
  end
  
  def self.find_by_participant_token(token)
    find_by(participant_uuid: token)
  end
  
  # Instance methods
  def admin_url
    # Generate admin URL using the admin token
    Rails.application.routes.url_helpers.potluck_admin_event_url(id, token: admin_uuid, host: Rails.application.config.action_mailer.default_url_options[:host])
  end
  
  def participant_url
    # Generate participant URL using the participant token
    Rails.application.routes.url_helpers.potluck_participate_url(token: participant_uuid, host: Rails.application.config.action_mailer.default_url_options[:host])
  end
  
  def toggle_notifications!
    update(email_notifications: !email_notifications)
  end
  
  def editable?
    # Can be edited until the event date
    event_date > Time.current
  end
  
  # Methods for items management
  def add_item(item_params)
    items.create(item_params)
  end
  
  def remove_item(item_id)
    items.find(item_id).destroy
  end
  
  # Methods for messaging participants
  def message_participant(participant_email, message)
    return unless email_notifications
    # Will implement mailer later
    # PotluckMailer.message_participant(self, participant_email, message).deliver_later
  end
  
  private
  
  def generate_uuids
    self.admin_uuid ||= SecureRandom.uuid
    self.participant_uuid ||= SecureRandom.uuid
  end
  
  def send_admin_confirmation
    # Will implement mailer later
    # PotluckMailer.admin_confirmation(self).deliver_later
  end
end
