# frozen_string_literal: true

require "test_helper"

class SurveyQuestionTest < ActiveSupport::TestCase
  test "valid with question" do
    survey = Survey.create!(name: "S")
    q = SurveyQuestion.new(survey: survey, question: "Como você avalia?")
    assert q.valid?
  end

  test "invalid without question" do
    survey = Survey.create!(name: "S")
    q = SurveyQuestion.new(survey: survey, question: nil)
    assert_not q.valid?
    assert q.errors[:question].present?
  end

  test "belongs to survey" do
    survey = Survey.create!(name: "Enquete")
    q = survey.survey_questions.create!(question: "P1?")
    assert_equal survey, q.survey
  end

  test "has_many survey_question_responses" do
    survey = Survey.create!(name: "S")
    q = survey.survey_questions.create!(question: "P1?")
    client = Client.create!(name: "C", email: "c@c.com")
    emp = Employee.create!(name: "E", corporation_email: "e@e.com", client: client)
    resp = SurveyQuestionResponse.create!(survey_question: q, employee: emp, value: 7)
    q.reload
    assert_includes q.survey_question_responses, resp
  end
end
