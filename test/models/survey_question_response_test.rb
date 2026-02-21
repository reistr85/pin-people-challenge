# frozen_string_literal: true

require "test_helper"

class SurveyQuestionResponseTest < ActiveSupport::TestCase
  test "valid with survey_question, employee and value" do
    survey = Survey.create!(name: "S")
    q = survey.survey_questions.create!(question: "P1?")
    client = Client.create!(name: "C", email: "c@c.com")
    emp = Employee.create!(name: "E", corporation_email: "e@e.com", client: client)

    resp = SurveyQuestionResponse.new(survey_question: q, employee: emp, value: 8)
    assert resp.valid?
  end

  test "valid with comment only" do
    survey = Survey.create!(name: "S")
    q = survey.survey_questions.create!(question: "Comentário?")
    client = Client.create!(name: "C", email: "c@c.com")
    emp = Employee.create!(name: "E", corporation_email: "e2@e.com", client: client)

    resp = SurveyQuestionResponse.new(survey_question: q, employee: emp, comment: "Texto livre")
    assert resp.valid?
  end

  test "invalid without survey_question" do
    client = Client.create!(name: "C", email: "c@c.com")
    emp = Employee.create!(name: "E", corporation_email: "e@e.com", client: client)
    resp = SurveyQuestionResponse.new(survey_question: nil, employee: emp, value: 5)
    assert_not resp.valid?
    assert resp.errors[:survey_question].present?
  end

  test "invalid without employee" do
    survey = Survey.create!(name: "S")
    q = survey.survey_questions.create!(question: "P1?")
    resp = SurveyQuestionResponse.new(survey_question: q, employee: nil, value: 5)
    assert_not resp.valid?
    assert resp.errors[:employee].present?
  end

  test "value must be 0..10 when present" do
    survey = Survey.create!(name: "S")
    q = survey.survey_questions.create!(question: "P?")
    client = Client.create!(name: "C", email: "c@c.com")
    emp = Employee.create!(name: "E", corporation_email: "e@e.com", client: client)
    r = SurveyQuestionResponse.new(survey_question: q, employee: emp, value: 11)
    assert_not r.valid?
    assert r.errors[:value].present?
  end

  test "belongs to survey_question and employee" do
    survey = Survey.create!(name: "S")
    q = survey.survey_questions.create!(question: "P1?")
    client = Client.create!(name: "C", email: "c@c.com")
    emp = Employee.create!(name: "E", corporation_email: "e@e.com", client: client)
    resp = SurveyQuestionResponse.create!(survey_question: q, employee: emp, value: 9)
    assert_equal q, resp.survey_question
    assert_equal emp, resp.employee
  end
end