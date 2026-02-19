# frozen_string_literal: true

module Api
  module V1
    class StatusController < BaseController
      def index
        render json: {
          version: "v1",
          status: "success"
        }
      end
    end
  end
end
