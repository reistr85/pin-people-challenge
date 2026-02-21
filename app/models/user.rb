# frozen_string_literal: true

class User < ApplicationRecord
  devise :database_authenticatable, :validatable

  before_save :ensure_auth_token

  def invalidate_token!
    update_column(:auth_token, nil)
  end

  def self.valid_token?(token)
    return false if token.blank?
    find_by(auth_token: token).present?
  end

  private

  def ensure_auth_token
    # only used for new record; API tokens are set on login
  end
end
