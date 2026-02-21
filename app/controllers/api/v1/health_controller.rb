# frozen_string_literal: true

module Api
  module V1
    class HealthController < BaseController
      skip_before_action :authenticate_user!

      # Liveness: app process is running
      def show
        head :ok
      end

      # Readiness: app is ready to receive traffic (optional: check DB, redis)
      def ready
        # ActiveRecord::Base.connection.execute("SELECT 1")
        head :ok
      rescue StandardError
        head :service_unavailable
      end
    end
  end
end
