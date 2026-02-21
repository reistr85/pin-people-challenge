# frozen_string_literal: true

module Api
  module V1
    class ClientsController < BaseController
      before_action :set_client, only: %i[show update destroy]
      before_action :authorize_clients_access!, only: %i[index show create update destroy]

      def index
        @clients = clients_scope.active.order(created_at: :desc)
      end

      def show
      end

      def create
        return forbid! unless current_user.admin?
        @client = Client.new(client_params.except(:user_id))
        user = build_user_for_client(@client)
        unless user
          render json: { errors: @client.errors.full_messages }, status: :unprocessable_entity
          return
        end
        @client.user_id = user.id
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
        return forbid! unless current_user.admin?
        @client.soft_delete
        head :no_content
      end

      private

      def authorize_clients_access!
        return if current_user.admin?
        return if current_user.client?
        forbid! if current_user.collaborator?
      end

      def clients_scope
        if current_user.admin?
          Client.all
        elsif current_user.client? && current_client
          Client.where(id: current_client.id)
        else
          Client.none
        end
      end

      def set_client
        @client = clients_scope.find_by!(uuid: params[:id])
      end

      def client_params
        list = %i[name email]
        list << :user_id if current_user.admin?
        params.require(:client).permit(list)
      end

      def build_user_for_client(client)
        email = client.email.presence || "client-#{SecureRandom.hex(4)}@placeholder.local"
        user = User.new(
          email: email,
          password: User::DEFAULT_PASSWORD,
          role: "client"
        )
        return user if user.save
        client.errors.merge!(user.errors)
        nil
      end
    end
  end
end