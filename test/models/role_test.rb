# frozen_string_literal: true

require "test_helper"

class RoleTest < ActiveSupport::TestCase
  test "valid with name" do
    role = Role.new(name: "Gestor")
    assert role.valid?
  end

  test "has_many employees" do
    role = Role.create!(name: "Profissional")
    emp = Employee.create!(name: "Pedro", role: role, client: nil, job_title: nil, departament: nil)
    role.reload
    assert_includes role.employees, emp
  end

  test "soft_delete" do
    role = Role.create!(name: "R")
    role.soft_delete
    assert role.reload.deleted?
  end
end
