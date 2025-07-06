class CreateVehicles < ActiveRecord::Migration[7.2]
  def change
    create_table :vehicles do |t|
      t.string :model
      t.string :number
      t.string :vehicle_type
      t.string :fuel_type
      t.float  :carbon_footprint
      t.string :parking_id

      t.timestamps
    end

    add_index :vehicles, :parking_id
  end
end
