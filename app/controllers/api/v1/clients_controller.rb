# frozen_string_literal: true

module Api
  module V1
    class ClientsController < BaseController
      before_action :set_client, only: %i[show update destroy]

      def index
        @clients = Client.active.order(created_at: :desc)
      end

      def show
      end

      def create
        @client = Client.new(client_params)
        unless @client.save
          render json: { errors: @client.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        unless @client.update(client_params)
          render json: { errors: @client.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        @client.soft_delete
        head :no_content
      end

      private

      def set_client
        @client = Client.find_by!(uuid: params[:uuid])
      end

      def client_params
        params.require(:client).permit(:name, :email)
      end
    end
  end
end