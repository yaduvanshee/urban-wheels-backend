class Ride < ApplicationRecord
  belongs_to :user
  belongs_to :vehicle

  has_one :payment, class_name: "Transaction"

  validate :user_cannot_have_multiple_active_rides, on: :create

  private

  def user_cannot_have_multiple_active_rides
    return unless user && vehicle

    has_active_ride = Ride
      .where(user_id: user.id, to_parking_id: nil)
      .exists?

    if has_active_ride
      errors.add(:base, "You already have a vehicle in use.")
    end
  end
end
