# frozen_string_literal: true

require "test_helper"

class EmployeeTest < ActiveSupport::TestCase
  test "valid with minimal attributes" do
    employee = Employee.new(name: "João", corporation_email: "joao@empresa.com")
    assert employee.valid?
  end

  test "belongs to client, job_title, departament, role" do
    client = Client.create!(name: "C", email: "c@c.com")
    job_title = JobTitle.create!(name: "Analista")
    dep = Departament.create!(name: "TI")
    role = Role.create!(name: "Profissional")

    employee = Employee.create!(
      name: "E",
      corporation_email: "e@e.com",
      client: client,
      job_title: job_title,
      departament: dep,
      role: role
    )
    assert_equal client, employee.client
    assert_equal job_title, employee.job_title
    assert_equal dep, employee.departament
    assert_equal role, employee.role
  end

  test "has_many survey_question_responses" do
    client = Client.create!(name: "C", email: "c@c.com")
    employee = Employee.create!(name: "E", corporation_email: "e@e.com", client: client)
    survey = Survey.create!(name: "S", client: client)
    question = survey.survey_questions.create!(question: "Pergunta 1?")
    resp = SurveyQuestionResponse.create!(survey_question: question, employee: employee, value: 8)
    employee.reload
    assert_includes employee.survey_question_responses, resp
  end

  test "valid with uf and city" do
    employee = Employee.new(name: "X", uf: "SP", city: "São Paulo")
    assert employee.valid?
  end
end
