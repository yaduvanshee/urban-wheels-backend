module Api
  module V1
    class AuthController < ApplicationController
      def login
        user = User.find_by(email: params[:email])
        if user&.authenticate(params[:password])
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
          }, status: :ok
        else
          render json: { error: "Invalid email or password" }, status: :unauthorized
        end
      end

      def me
        header = request.headers["Authorization"]
        token = header&.split(" ")&.last

        if token.blank?
          render json: { error: "Missing token" }, status: :unauthorized and return
        end

        decoded = JsonWebToken.decode(token)
        user_id = decoded&.[](:user_id)

        if user_id.present?
          @current_user = User.find_by(id: user_id)
          if @current_user
            render json: @current_user, status: :ok
          else
            render json: { error: "User not found" }, status: :not_found
          end
        else
          render json: { error: "Invalid token" }, status: :unauthorized
        end
      end
    end
  end
end
