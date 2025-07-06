class RideSerializer < ActiveModel::Serializer
  attributes :id, :from_parking_id, :to_parking_id,
             :distance_covered, :journey_time,
             :carbon_emission, :created_at

  belongs_to :vehicle, serializer: VehicleSerializer
  belongs_to :payment
end
