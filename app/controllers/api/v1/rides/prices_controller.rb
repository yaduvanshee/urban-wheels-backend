class Api::V1::Rides::PricesController < Api::V1::BaseController
  def index
    prices = params[:vehicle_type] ? VehiclePrice.find_by_vehicle_type(params[:vehicle_type]): VehiclePrice.all

    render json: prices, status: :ok
  end
end
