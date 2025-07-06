require "rest-client"
require "json"

class Api::V1::ParkingSpots::ParkingsController < Api::V1::BaseController
  def index
    pincode = params[:pincode] || "110001"
    postal_data = fetch_postal_data(pincode)

    if postal_data.blank?
      render json: { error: "Could not fetch postal data" }, status: :bad_request and return
    end

    post_offices = postal_data.dig(0, "PostOffice") || []

    parking_spots = post_offices.map do |office|
      {
        unique_id: "#{office['Pincode']}-#{office['Name']}".parameterize,
        name: "#{office['Name']} Parking",
        location: "#{office['District']}, #{office['State']}",
        pincode: office["Pincode"],
        office_type: office["BranchType"]
      }
    end

    render json: { pincode: pincode, spots: parking_spots }
  end

  def list_vehicles
    parking_id = params[:parking_id]

    if parking_id.blank?
      return render json: { error: "parking_id is required" }, status: :bad_request
    end

    vehicles = Vehicle.where(parking_id: parking_id).order(created_at: :desc)

    render json: {
      list: ActiveModelSerializers::SerializableResource.new(vehicles, each_serializer: VehicleSerializer)
    }
  end

  private

  def fetch_postal_data(pincode)
    url = "https://api.postalpincode.in/pincode/#{pincode}"
    response = RestClient.get(url)
    JSON.parse(response.body)
  rescue RestClient::ExceptionWithResponse => e
    Rails.logger.error "Postal API error: #{e.response}"
    nil
  rescue StandardError => e
    Rails.logger.error "Postal API exception: #{e.message}"
    nil
  end
end
