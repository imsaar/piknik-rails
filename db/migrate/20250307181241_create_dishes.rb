class CreateDishes < ActiveRecord::Migration[7.0]
  def change
    create_table :dishes do |t|
      t.string :name
      t.text :description
      t.integer :quantity_needed
      t.integer :quantity_signed_up
      t.references :event, null: false, foreign_key: true

      t.timestamps
    end
  end
end
