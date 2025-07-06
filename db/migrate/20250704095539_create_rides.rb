class CreateRides < ActiveRecord::Migration[7.2]
  def change
    create_table :rides do |t|
      t.string :from_parking_id
      t.string :to_parking_id
      t.float :distance_covered
      t.integer :journey_time
      t.float :carbon_emission
      t.references :user, null: false, foreign_key: true
      t.references :vehicle, null: false, foreign_key: true

      t.timestamps
    end
  end
end
