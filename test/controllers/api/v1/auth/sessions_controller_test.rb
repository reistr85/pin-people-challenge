# frozen_string_literal: true

require "test_helper"

module Api
  module V1
    module Auth
      class SessionsControllerTest < ActionDispatch::IntegrationTest
        test "sign_in returns token and user" do
          user = User.create!(email: "u@test.com", password: User::DEFAULT_PASSWORD, role: "admin")
          post api_v1_auth_sign_in_path, params: { session: { email: "u@test.com", password: User::DEFAULT_PASSWORD } }, as: :json
          assert_response :success
          json = response.parsed_body
          assert json["token"].present?
          assert_equal "admin", json["user"]["role"]
        end

        test "sign_in with wrong password returns 401" do
          User.create!(email: "u@test.com", password: User::DEFAULT_PASSWORD, role: "admin")
          post api_v1_auth_sign_in_path, params: { session: { email: "u@test.com", password: "wrong" } }, as: :json
          assert_response :unauthorized
        end

        test "me returns current user" do
          user = User.create!(email: "me@test.com", password: User::DEFAULT_PASSWORD, role: "client")
          user.update_column(:auth_token, "t123")
          get api_v1_auth_me_path, headers: { "Authorization" => "Bearer t123" }, as: :json
          assert_response :success
          assert_equal "me@test.com", response.parsed_body["user"]["email"]
        end

        test "sign_out invalidates token" do
          user = User.create!(email: "out@test.com", password: User::DEFAULT_PASSWORD, role: "admin")
          user.update_column(:auth_token, "t456")
          delete api_v1_auth_sign_out_path, headers: { "Authorization" => "Bearer t456" }
          assert_response :no_content
          assert user.reload.auth_token.nil?
        end
      end
    end
  end
end
