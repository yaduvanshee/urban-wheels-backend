module Api
  module V1
    class UsersController < BaseController
      skip_before_action :authorize_request, only: [ :create ]

      def create
        user = User.new(user_params.merge(type: "User", wallet_balance: 1000.0))
        if user.save
          token = JsonWebToken.encode(user_id: user.id)
          render json: {
            token: token,
            user: {
              id: user.id,
              email: user.email,
              first_name: user.first_name,
              last_name: user.last_name,
              type: user.type,
              wallet_balance: user.wallet_balance
            }
          }, status: :created
        else
          render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def user_params
        params.permit(:first_name, :last_name, :email, :password, :password_confirmation)
      end
    end
  end
end
