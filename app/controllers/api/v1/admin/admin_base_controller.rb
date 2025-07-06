class Api::V1::Admin::AdminBaseController < Api::V1::BaseController
  before_action :validate_admin

  private

  def validate_admin
    unless @current_user
      render json: { error: "Unauthorized: #{@current_user ? @current_user&.first_name : 'no user found'}" }, status: :unauthorized and return
    end

    unless @current_user.is_admin?
      render json: { error: "Forbidden: Admins only" }, status: :forbidden and return
    end
  end
end
