class CreatePotluckEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :potluck_events do |t|
      t.string :name, null: false
      t.date :event_date, null: false
      t.string :theme
      t.string :admin_email, null: false
      t.string :admin_name
      t.string :admin_uuid, null: false
      t.string :participant_uuid, null: false
      t.boolean :email_notifications, default: true
      
      t.timestamps
    end
    
    add_index :potluck_events, :admin_uuid, unique: true
    add_index :potluck_events, :participant_uuid, unique: true
  end
end
