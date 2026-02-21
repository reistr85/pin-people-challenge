# frozen_string_literal: true

module Api
  module V1
    class BaseController < ApplicationController
      before_action :force_json_format
      before_action :authenticate_user!

      attr_reader :current_user

      private

      def force_json_format
        request.format = :json
      end

      def authenticate_user!
        token = request.headers["Authorization"]&.split(" ")&.last
        @current_user = User.find_by(auth_token: token) if token.present?
        return if @current_user

        render json: { error: "Não autorizado" }, status: :unauthorized
      end
    end
  end
end
