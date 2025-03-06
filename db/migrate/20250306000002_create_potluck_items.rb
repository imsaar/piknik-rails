class CreatePotluckItems < ActiveRecord::Migration[7.0]
  def change
    create_table :potluck_items do |t|
      t.references :potluck_event, null: false, foreign_key: true
      t.string :name, null: false
      t.integer :quantity_needed, default: 1
      t.integer :quantity_signed_up, default: 0
      t.text :description
      
      t.timestamps
    end
  end
end
