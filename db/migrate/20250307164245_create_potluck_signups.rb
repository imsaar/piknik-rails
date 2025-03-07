class CreatePotluckSignups < ActiveRecord::Migration[7.0]
  def change
    create_table :potluck_signups do |t|
      t.references :potluck_item, null: false, foreign_key: true
      t.string :email
      t.string :name
      t.integer :quantity
      t.boolean :confirmed
      t.string :confirmation_token

      t.timestamps
    end
  end
end
