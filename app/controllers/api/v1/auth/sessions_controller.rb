# frozen_string_literal: true

module Api
  module V1
    module Auth
      class SessionsController < Api::V1::BaseController
        skip_before_action :authenticate_user!, only: [:create]

        def create
          user = User.find_for_database_authentication(email: session_params[:email])
          if user&.valid_password?(session_params[:password])
            user.update_column(:auth_token, SecureRandom.urlsafe_base64(32))
            render json: {
              token: user.auth_token,
              user: { id: user.id, email: user.email }
            }
          else
            render json: { error: "Email ou senha inválidos" }, status: :unauthorized
          end
        end

        def destroy
          current_user.invalidate_token!
          head :no_content
        end

        def me
          render json: { user: { id: current_user.id, email: current_user.email } }
        end

        private

        def session_params
          params.require(:session).permit(:email, :password)
        end
      end
    end
  end
end
