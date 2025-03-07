class CreateSignups < ActiveRecord::Migration[7.0]
  def change
    create_table :signups do |t|
      t.references :dish, null: false, foreign_key: true
      t.string :participant_name
      t.string :participant_email
      t.integer :quantity
      t.boolean :confirmed

      t.timestamps
    end
  end
end
