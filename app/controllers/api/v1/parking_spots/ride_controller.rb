class Api::V1::ParkingSpots::RideController < Api::V1::BaseController
  def create_ride
    vehicle = Vehicle.find_by(id: params[:vehicle_id])

    if vehicle.blank? || vehicle.in_use?
      return render json: { error: "Vehicle not available" }, status: :unprocessable_entity
    end

    user = @current_user
    price = VehiclePrice.find_by(vehicle_type: vehicle.vehicle_type)&.price

    unless price
      return render json: { error: "No Price found for this vehicle Type" }, status: :unprocessable_entity
    end

    if user.wallet_balance < price
      return render json: { error: "Insufficient wallet balance" }, status: :payment_required
    end

    Ride.transaction do
      ride = Ride.create!(
        from_parking_id: vehicle.parking_id,
        user: user,
        vehicle: vehicle,
        journey_time: 0,
        )

        user.update!(wallet_balance: user.wallet_balance - price)

        vehicle.update!(state: "in_use", parking_id: nil)

      Transaction.create!(
        user: user,
        ride: ride,
        amount_paid: price
      )

      render json: { message: "Ride started successfully", ride_id: ride.id }, status: :created
    end
  rescue ActiveRecord::RecordInvalid => e
    render json: { error: e.record.errors.full_messages }, status: :unprocessable_entity
  end

  def complete
    ride = Ride.find(params[:ride_id])
    vehicle = ride.vehicle

    if ride.user_id != @current_user.id
      render json: { error: "Unauthorized" }, status: :unauthorized
      return
    end

    journey_duration_minutes = ((Time.zone.now - ride.created_at) / 60).round
    distance_covered = calculate_distance(ride, params[:parking_id])
    carbon_emission = vehicle.carbon_footprint * distance_covered

    Ride.transaction do
      ride.update!(
        journey_time: journey_duration_minutes,
        to_parking_id: params[:parking_id],
        distance_covered: distance_covered,
        carbon_emission: carbon_emission,
      )

      vehicle.update!(
        parking_id: params[:parking_id],
        state: "available"
      )

      render json: { message: "Ride completed successfully" }
    end
  rescue ActiveRecord::RecordInvalid => e
    render json: { error: e.record.errors.full_messages }, status: :unprocessable_entity
  end

  private

  def calculate_distance(ride, to_parking_id)
    from_pin = extract_pincode(ride.from_parking_id)
    to_pin   = extract_pincode(to_parking_id)

    return rand(2..10) unless from_pin.present? && to_pin.present?

    from = from_pin.chars.map(&:to_i)
    to   = to_pin.chars.map(&:to_i)

    zone_diff      = (from[0] - to[0]).abs * 50
    subzone_diff   = (from[1] - to[1]).abs * 20
    district_diff  = (from[2] - to[2]).abs * 10
    sector_diff    = (from[3] - to[3]).abs * 5
    subsect_diff   = (from[4] - to[4]).abs * 2
    delivery_diff  = (from[5] - to[5]).abs * 1

    total_distance = zone_diff + subzone_diff + district_diff + sector_diff + subsect_diff + delivery_diff
    total_distance
  rescue
    rand(2..10)
  end

  def extract_pincode(parking_id)
    parking_id.to_s.split("-").first
  end

  def calculate_emission(vehicle)
    case vehicle.fuel_type
    when "petrol" then 2.3
    when "diesel" then 2.7
    when "electric" then 0.2
    else 1.0
    end
  end
end
