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
              user: user_json(user)
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
          render json: { user: user_json(current_user) }
        end

        private

        def session_params
          params.require(:session).permit(:email, :password)
        end

        def user_json(u)
          payload = { id: u.id, email: u.email, role: u.role }
          payload[:client_uuid] = u.client.uuid if u.client? && u.client.present?
          payload[:employee_uuid] = u.employee.uuid if u.collaborator? && u.employee.present?
          payload
        end
      end
    end
  end
end
