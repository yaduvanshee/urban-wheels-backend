class Api::V1::Admin::VehicleController < Api::V1::Admin::AdminBaseController
  POSSIBLE_FILTERS = [ :parking_id ]
  POSSIBLE_INDIRECT_FILTER = [ :q ]

  before_action :set_vehicle, only: [ :show, :update, :destroy, :list_history ]

  def index
    @vehicle = get_data

    response = {
      list: ActiveModelSerializers::SerializableResource.new(
        @vehicle,
        each_serializer: VehicleSerializer
      ),
      current_page: @vehicle.current_page,
      per_page: @vehicle.limit_value,
      total_pages: @vehicle.total_pages,
      total_count: @vehicle.total_count
    }

    render json: response, status: :ok
  end

  def update
    if @vehicle.update(vehicle_params)
      render json: @vehicle, serializer: VehicleSerializer, status: :ok
    else
      render json: { error: @vehicle.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def list_history
    rides = @vehicle.rides
               .includes(:payment, :user)
               .order(updated_at: :desc)
               .page(params[:page] || 1)
               .per(params[:per_page] || 10)

    response = {
      list: rides.map do |ride|
        {
          id: ride.id,
          from_parking_id: ride.from_parking_id,
          to_parking_id: ride.to_parking_id,
          distance_covered: ride.distance_covered,
          journey_time: ride.journey_time,
          carbon_emission: ride.carbon_emission,
          created_at: ride.created_at,
          updated_at: ride.updated_at,
          transaction: ride.payment && {
            id: ride.payment.id,
            amount_paid: ride.payment.amount_paid,
            created_at: ride.payment.created_at
          }
        }
      end,
      current_page: rides.current_page,
      per_page: rides.limit_value,
      total_pages: rides.total_pages,
      total_count: rides.total_count,
      total_revenue: @vehicle.rides.joins(:payment).sum("transactions.amount_paid") || 0
    }

    render json: response
  end

  def create
    @vehicle = Vehicle.build(vehicle_params)
    if @vehicle.save
      render json: @vehicle, status: :created
    else
      render json: { error: @vehicle.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def show
    render json: @vehicle, serializer: VehicleSerializer
  end

  def destroy
    @vehicle.destroy
    head :no_content
  end

  private

  def get_data
    query = get_query
    query = query.where(get_direct_filters)
    query = apply_indirect_filters(query)
    query.page(params[:page]).per(params[:per_page] || 10)
  end

  def get_query
    Vehicle.order(updated_at: :desc)
  end

  def apply_indirect_filters(query)
    indirect_filters = params.select { |key, value| POSSIBLE_INDIRECT_FILTER.include?(key.to_sym) && value.present? } rescue {}

    indirect_filters.each do |key, value|
      method_name = "apply_#{key}_filter"
      query = send(method_name, query, value)
    end

    query
  end

  def set_vehicle
    @vehicle = Vehicle.find(params[:id])
  end

  def apply_q_filter(query, value)
    query.where("model ILIKE :v OR number ILIKE :v OR vehicle_type ILIKE :v", v: "%#{value}%")
  end

  def get_direct_filters
    { parking_id: params[:parking_id] }.compact
  end

  def vehicle_params
    params.require(:vehicle).permit(:model, :number, :owner_name, :vehicle_type, :fuel_type, :carbon_footprint, :parking_id)
  end
end
