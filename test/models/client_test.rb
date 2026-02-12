# frozen_string_literal: true

require "test_helper"

class ClientTest < ActiveSupport::TestCase
  test "valid with name and email" do
    client = Client.new(name: "Empresa X", email: "contato@empresa.com")
    assert client.valid?
  end

  test "has_many employees" do
    client = Client.create!(name: "Cliente", email: "c@c.com")
    emp = Employee.create!(name: "E", client: client, job_title: nil, departament: nil, role: nil)
    client.reload
    assert_includes client.employees, emp
  end

  test "has_many surveys" do
    client = Client.create!(name: "Cliente", email: "c@c.com")
    survey = Survey.create!(name: "Enquete", client: client)
    client.reload
    assert_includes client.surveys, survey
  end

  test "active scope" do
    Client.create!(name: "A")
    Client.create!(name: "B", deleted_at: Time.current)
    assert_equal 1, Client.active.count
  end
end
