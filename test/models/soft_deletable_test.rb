# frozen_string_literal: true

require "test_helper"

class SoftDeletableTest < ActiveSupport::TestCase
  test "concern provides active and deleted scopes" do
    assert JobTitle.respond_to?(:active)
    assert JobTitle.respond_to?(:deleted)
  end

  test "concern provides soft_delete and deleted?" do
    job_title = JobTitle.create!(name: "Test")
    assert_not job_title.deleted?
    job_title.soft_delete
    assert job_title.deleted?
  end
end