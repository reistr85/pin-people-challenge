# frozen_string_literal: true

require "test_helper"

module Api
  module V1
    class SurveysControllerTest < ActionDispatch::IntegrationTest
      include ApiTestHelpers

      setup do
        @admin = User.create!(email: "admin@test.com", password: User::DEFAULT_PASSWORD, role: "admin")
        @admin.update_column(:auth_token, "admin-token")
        @client = Client.create!(name: "Cliente", email: "c@c.com")
      end

      test "index requires auth" do
        get api_v1_surveys_path, as: :json
        assert_response :unauthorized
      end

      test "index as admin returns surveys" do
        s = Survey.create!(name: "Enquete", client: @client)
        get api_v1_surveys_path, headers: api_auth_headers(@admin), as: :json
        assert_response :success
        assert response.parsed_body.any? { |h| h["uuid"] == s.uuid }
      end

      test "create as admin creates survey" do
        assert_difference "Survey.count", 1 do
          post api_v1_surveys_path,
            params: { survey: { name: "Nova", description: "Desc", client_uuid: @client.uuid } },
            headers: api_auth_headers(@admin),
            as: :json
        end
        assert_response :success
      end

      test "show returns survey with questions" do
        s = Survey.create!(name: "S", client: @client)
        s.survey_questions.create!(question: "P1?")
        get api_v1_survey_path(s.uuid), headers: api_auth_headers(@admin), as: :json
        assert_response :success
        assert_equal s.uuid, response.parsed_body["uuid"]
        assert response.parsed_body["survey_questions"].length == 1
      end

      test "responses as collaborator saves responses" do
        user = User.create!(email: "colab@e.com", password: User::DEFAULT_PASSWORD, role: "collaborator")
        user.update_column(:auth_token, "colab-token")
        emp = Employee.create!(name: "Colab", corporation_email: "colab@e.com", client: @client, user_id: user.id)
        survey = Survey.create!(name: "Enquete", client: @client)
        q = survey.survey_questions.create!(question: "Nota?")
        put responses_api_v1_survey_path(survey.uuid),
          params: { responses: [ { survey_question_uuid: q.uuid, value: 8, comment: "Ok" } ] },
          headers: api_auth_headers(user),
          as: :json
        assert_response :success
        r = emp.survey_question_responses.find_by(survey_question_id: q.id)
        assert r
        assert_equal 8, r.value
        assert_equal "Ok", r.comment
      end
    end
  end
end
