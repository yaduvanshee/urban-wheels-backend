
VehiclePrice.create!([
  { id: 1, vehicle_type: "car", price: 100.0 },
  { id: 2, vehicle_type: "bike", price: 50.0 },
  { id: 3, vehicle_type: "scooter", price: 600.0 },
  { id: 4, vehicle_type: "cycle", price: 40.0 }
])


User.create!(
  type: "Admin",
  email: "admin@example.com",
  first_name: "Admin",
  last_name: "User",
  password: "password",
  wallet_balance: 1000.0
)

User.create!([
  {
    email: "user1@gmail.com",
    first_name: "User",
    last_name: "One",
    password: "password",
    wallet_balance: 500.0
  },
  {
    email: "user2@gmail.com",
    first_name: "User",
    last_name: "Two",
    password: "password",
    wallet_balance: 300.0
  }
])
