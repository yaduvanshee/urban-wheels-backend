class VehiclePrice < ApplicationRecord
  validates :vehicle_type, presence: true, uniqueness: true, inclusion: {
    in: %w[car bike scooter cycle],
    message: "%{value} is not a valid vehicle type"
  }

  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
end
