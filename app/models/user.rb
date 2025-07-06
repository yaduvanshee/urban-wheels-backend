class User < ApplicationRecord
  self.inheritance_column = "type"

  has_secure_password

  validates :email, presence: true, uniqueness: true
  validates :first_name, :last_name, presence: true
  validates :wallet_balance, numericality: { greater_than_or_equal_to: 0 }

  has_many :rides
  has_many :transactions

  has_one :current_ride, -> {
    where(to_parking_id: nil)
      .joins(:vehicle)
      .where(vehicles: { state: "in_use" })
  }, class_name: "Ride"

  def is_admin?
    self.is_a?(Admin)
  end

  def convert_to_admin
    update(type: "Admin")
  end

  def full_name
    "#{first_name} #{last_name}"
  end
end
