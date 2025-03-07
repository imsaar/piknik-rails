class CreateEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :events do |t|
      t.string :name
      t.text :description
      t.datetime :date
      t.string :location
      t.string :code

      t.timestamps
    end
  end
end
