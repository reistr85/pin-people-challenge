# frozen_string_literal: true

require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "valid with email, password and role" do
    user = User.new(email: "admin@test.com", password: "12345678", role: "admin")
    assert user.valid?
  end

  test "role must be in ROLES" do
    user = User.new(email: "u@u.com", password: "12345678", role: "invalid")
    assert_not user.valid?
    assert user.errors[:role].present?
  end

  test "admin? client? collaborator?" do
    %w[admin client collaborator].each do |role|
      u = User.create!(email: "#{role}@t.com", password: User::DEFAULT_PASSWORD, role: role)
      assert u.public_send("#{role}?")
    end
  end

  test "valid_token? returns true for existing token" do
    user = User.create!(email: "t@t.com", password: "12345678", role: "admin")
    user.update_column(:auth_token, "abc123")
    assert User.valid_token?("abc123")
    assert_not User.valid_token?("wrong")
  end

  test "invalidate_token! clears auth_token" do
    user = User.create!(email: "x@x.com", password: "12345678", role: "admin")
    user.update_column(:auth_token, "xyz")
    user.invalidate_token!
    assert user.reload.auth_token.nil?
  end
end
