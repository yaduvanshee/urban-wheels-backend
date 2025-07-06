class AddStateToVehicles < ActiveRecord::Migration[7.2]
  def change
    add_column :vehicles, :state, :string
  end
end
