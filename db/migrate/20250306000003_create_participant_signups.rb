class CreateParticipantSignups < ActiveRecord::Migration[7.0]
  def change
    create_table :participant_signups do |t|
      t.references :potluck_item, null: false, foreign_key: true
      t.string :email, null: false
      t.string :name
      t.integer :quantity, default: 1
      t.string :confirmation_uuid, null: false
      t.boolean :confirmed, default: false
      
      t.timestamps
    end
    
    add_index :participant_signups, :confirmation_uuid, unique: true
  end
end
