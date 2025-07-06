class Api::V1::Rides::RideController < Api::V1::BaseController
  def my_ride
    if @current_user.current_ride.present?
      render json: @current_user.current_ride, serializer: RideSerializer
    else
      render json: nil, status: :ok
    end
  end

  def history
    page     = params[:page] || 1
    per_page = params[:per_page] || 10

    paginated_rides = @current_user.rides.includes(:payment, :vehicle)
                                    .order(updated_at: :desc)
                                    .page(page)
                                    .per(per_page)

    render json: {
      list: ActiveModelSerializers::SerializableResource.new(paginated_rides, each_serializer: RideSerializer),
      current_page: paginated_rides.current_page,
      per_page: paginated_rides.limit_value,
      total_pages: paginated_rides.total_pages,
      total_count: paginated_rides.total_count
    }
  end
end
