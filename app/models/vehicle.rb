class Vehicle < ApplicationRecord
  include AASM

  validates :model, presence: true
  validates :number, presence: true, uniqueness: true
  validates :parking_id, presence: true, unless: -> { state == "in_use" }

  validates :vehicle_type, presence: true, inclusion: {
    in: %w[car bike scooter cycle],
    message: "%{value} is not a valid vehicle type"
  }

  validates :fuel_type, presence: true, inclusion: {
    in: %w[petrol diesel electric hybrid none],
    message: "%{value} is not a valid fuel type"
  }

  validates :carbon_footprint, presence: true, numericality: { greater_than_or_equal_to: 0 }

  has_one :rate, -> { where(vehicle_type: vehicle_type) }, class_name: "VehiclePrice"
  has_many :rides

  aasm column: :state do
    state :available, initial: true
    state :in_use

    event :start_ride do
      transitions from: :available, to: :in_use
    end

    event :end_ride do
      transitions from: :in_use, to: :available
    end
  end
end
