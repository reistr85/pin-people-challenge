# frozen_string_literal: true

require "test_helper"

module Api
  module V1
    class ClientsControllerTest < ActionDispatch::IntegrationTest
      include ApiTestHelpers

      setup do
        @admin = User.create!(email: "admin@test.com", password: User::DEFAULT_PASSWORD, role: "admin")
        @admin.update_column(:auth_token, "admin-token")
      end

      test "index requires auth" do
        get api_v1_clients_path, as: :json
        assert_response :unauthorized
      end

      test "index as admin returns clients" do
        c = Client.create!(name: "Cliente A", email: "a@a.com")
        get api_v1_clients_path, headers: api_auth_headers(@admin), as: :json
        assert_response :success
        assert response.parsed_body.is_a?(Array)
        assert response.parsed_body.any? { |h| h["uuid"] == c.uuid }
      end

      test "create as admin creates client and user" do
        assert_difference [ "Client.count", "User.count" ], 1 do
          post api_v1_clients_path,
            params: { client: { name: "Novo", email: "novo@c.com" } },
            headers: api_auth_headers(@admin),
            as: :json
        end
        assert_response :success
        client = Client.find_by(email: "novo@c.com")
        assert client
        assert client.user_id.present?
      end

      test "show returns client by uuid" do
        c = Client.create!(name: "Show", email: "show@c.com")
        get api_v1_client_path(c.uuid), headers: api_auth_headers(@admin), as: :json
        assert_response :success
        assert_equal c.uuid, response.parsed_body["uuid"]
      end

      test "destroy as admin soft-deletes" do
        c = Client.create!(name: "Del", email: "del@c.com")
        delete api_v1_client_path(c.uuid), headers: api_auth_headers(@admin)
        assert_response :no_content
        assert c.reload.deleted?
      end
    end
  end
end
