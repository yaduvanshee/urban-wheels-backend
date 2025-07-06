class VehicleSerializer < ActiveModel::Serializer
  attributes :id, :model, :number, :vehicle_type, :fuel_type, :carbon_footprint, :parking_id, :created_at, :state
end
