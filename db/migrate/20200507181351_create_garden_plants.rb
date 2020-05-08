class CreateGardenPlants < ActiveRecord::Migration[6.0]
  def change
    create_table :garden_plants do |t|
      t.string :name, null: false
      t.string :variety
      t.integer :max_days_to_maturity, null: false
      t.integer :min_days_to_maturity, null: false
      t.integer :max_days_to_germ, null: false
      t.integer :min_days_to_germ, null: false
      t.datetime :created_at
    end
  end
end
