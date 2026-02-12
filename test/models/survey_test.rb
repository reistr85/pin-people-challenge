# frozen_string_literal: true

require "test_helper"

class SurveyTest < ActiveSupport::TestCase
  test "valid with name" do
    survey = Survey.new(name: "Pesquisa de Clima")
    assert survey.valid?
  end

  test "belongs to client optional" do
    survey = Survey.create!(name: "S")
    assert_nil survey.client

    client = Client.create!(name: "C", email: "c@c.com")
    survey.update!(client: client)
    assert_equal client, survey.reload.client
  end

  test "has_many survey_questions" do
    survey = Survey.create!(name: "Enquete")
    q1 = survey.survey_questions.create!(question: "Pergunta 1?")
    q2 = survey.survey_questions.create!(question: "Pergunta 2?")
    survey.reload
    assert_equal 2, survey.survey_questions.count
    assert_includes survey.survey_questions, q1
    assert_includes survey.survey_questions, q2
  end

  test "soft_deletable" do
    survey = Survey.create!(name: "S")
    survey.soft_delete
    assert survey.reload.deleted?
  end
end
