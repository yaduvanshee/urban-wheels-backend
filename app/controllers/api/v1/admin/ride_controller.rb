class Api::V1::Admin::RideController < Api::V1::Admin::AdminBaseController
  def index
    revenue_data = Ride
      .left_joins(:payment)
      .group(:from_parking_id)
      .select(
        :from_parking_id,
        "SUM(rides.carbon_emission) AS total_carbon_emission",
        "SUM(transactions.amount_paid) AS total_amount_paid",
        "COUNT(rides.id) AS total_rides"
      )
      .order("total_amount_paid DESC NULLS LAST") # Optional: order by revenue
      .limit(5)

    render json: revenue_data.map { |record|
      {
        from_parking_id: record.from_parking_id,
        total_carbon_emission: record.total_carbon_emission.to_f.round(2),
        total_amount_paid: record.total_amount_paid.to_f.round(2),
        total_rides: record.total_rides
      }
    }
  end

  def parking_stats
    parking_id = params[:parking_id]

    rides = Ride.where(from_parking_id: parking_id)

    total_rides = rides.count
    total_carbon_emission = rides.sum(:carbon_emission)
    total_amount_paid = Transaction.joins(:ride).where(rides: { from_parking_id: parking_id }).sum(:amount_paid)
    unique_vehicles = rides.select(:vehicle_id).distinct.count
    average_distance = rides.average(:distance_covered)&.round(2) || 0

    render json: {
      parking_id: parking_id,
      total_rides: total_rides,
      total_carbon_emission: total_carbon_emission,
      total_amount_paid: total_amount_paid,
      unique_vehicles: unique_vehicles,
      average_distance: average_distance
    }
  end
end
