# frozen_string_literal: true

require "test_helper"

class DepartamentTest < ActiveSupport::TestCase
  test "valid with name" do
    dep = Departament.new(name: "Tecnologia")
    assert dep.valid?
  end

  test "has_many employees" do
    dep = Departament.create!(name: "RH")
    emp = Employee.create!(name: "Maria", departament: dep, client: nil, job_title: nil, role: nil)
    dep.reload
    assert_includes dep.employees, emp
  end

  test "active scope excludes deleted" do
    Departament.create!(name: "A")
    Departament.create!(name: "B", deleted_at: Time.current)
    assert_equal 1, Departament.active.count
  end
end
