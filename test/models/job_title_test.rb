# frozen_string_literal: true

require "test_helper"

class JobTitleTest < ActiveSupport::TestCase
  test "valid with name" do
    job_title = JobTitle.new(name: "Analista")
    assert job_title.valid?
  end

  test "valid without name" do
    job_title = JobTitle.new(name: nil)
    assert job_title.valid?
  end

  test "has_many employees" do
    job_title = JobTitle.create!(name: "Gerente")
    employee = Employee.create!(
      name: "João",
      job_title: job_title,
      client: nil,
      departament: nil,
      role: nil
    )
    job_title.reload
    assert_includes job_title.employees, employee
  end

  test "soft_deletable scope active" do
    JobTitle.create!(name: "A")
    JobTitle.create!(name: "B", deleted_at: 1.day.ago)
    assert_equal 1, JobTitle.active.count
  end

  test "soft_delete sets deleted_at" do
    job_title = JobTitle.create!(name: "Cargo")
    job_title.soft_delete
    assert job_title.reload.deleted?
  end
end
