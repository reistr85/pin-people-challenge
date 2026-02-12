# frozen_string_literal: true

module Api
  module V1
    class ClientsController < ApplicationController
      include ApiJsonWithoutId

      before_action :set_client, only: %i[show update destroy]

      def index
        clients = Client.active.order(created_at: :desc)
        render json: api_json(clients)
      end

      def show
        render json: api_json(@client)
      end

      def create
        client = Client.new(client_params)
        if client.save
          render json: api_json(client), status: :created
        else
          render json: { errors: client.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        if @client.update(client_params)
          render json: api_json(@client)
        else
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