class Api::V1::BaseController < ApplicationController
  before_action :authorize_request

  private

  def authorize_request
    header = request.headers["Authorization"]
    token = header&.split(" ")&.last

    if token.blank?
      render json: { error: "Missing token" }, status: :unauthorized and return
    end

    decoded = JsonWebToken.decode(token)
    @current_user = User.find(decoded[:user_id]) if decoded&.[](:user_id)
  rescue => e
    render json: { error: "Unauthorized: #{e.message}" }, status: :unauthorized and return
  end
end
