class CreateVehiclePrices < ActiveRecord::Migration[7.2]
  def change
    create_table :vehicle_prices do |t|
      t.string :vehicle_type
      t.decimal :price

      t.timestamps
    end
  end
end
