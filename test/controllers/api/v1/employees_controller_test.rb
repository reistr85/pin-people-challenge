# frozen_string_literal: true

require "test_helper"

module Api
  module V1
    class EmployeesControllerTest < ActionDispatch::IntegrationTest
      include ApiTestHelpers

      setup do
        @admin = User.create!(email: "admin@test.com", password: User::DEFAULT_PASSWORD, role: "admin")
        @admin.update_column(:auth_token, "admin-token")
        @client = Client.create!(name: "Empresa", email: "emp@e.com")
      end

      test "index requires auth" do
        get api_v1_employees_path, as: :json
        assert_response :unauthorized
      end

      test "index as admin returns employees" do
        emp = Employee.create!(name: "João", corporation_email: "joao@e.com", client: @client)
        get api_v1_employees_path, headers: api_auth_headers(@admin), as: :json
        assert_response :success
        assert response.parsed_body["data"].is_a?(Array)
      end

      test "create as admin creates employee and user" do
        assert_difference [ "Employee.count", "User.count" ], 1 do
          post api_v1_employees_path,
            params: { employee: { name: "Maria", corporation_email: "maria@e.com", client_uuid: @client.uuid } },
            headers: api_auth_headers(@admin),
            as: :json
        end
        assert_response :success
        emp = Employee.find_by(corporation_email: "maria@e.com")
        assert emp
        assert emp.user_id.present?
      end

      test "show returns employee by uuid" do
        emp = Employee.create!(name: "Show", corporation_email: "show@e.com", client: @client)
        get api_v1_employee_path(emp.uuid), headers: api_auth_headers(@admin), as: :json
        assert_response :success
        assert_equal emp.uuid, response.parsed_body["uuid"]
      end
    end
  end
end
