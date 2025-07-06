class Api::V1::Admin::PricesController < Api::V1::Admin::AdminBaseController
  before_action :set_price, only: [ :show, :update, :destroy ]

  def index
    prices = VehiclePrice.all
    render json: prices, status: :ok
  end

  def show
    render json: @price, status: :ok
  end

  def update
    if @price.update(price_params)
      render json: @price, status: :ok
    else
      render json: { errors: @price.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @price.destroy
    render json: { message: "Price deleted successfully" }, status: :ok
  end

  private

  def set_price
    @price = VehiclePrice.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Price not found" }, status: :not_found
  end

  def price_params
    params.require(:vehicle_price).permit(:price)
  end
end
