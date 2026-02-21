# frozen_string_literal: true

module Api
  module V1
    class StatusController < BaseController
      skip_before_action :authenticate_user!

      def index
        render json: {
          version: "v1",
          status: "success"
        }
      end
    end
  end
end
