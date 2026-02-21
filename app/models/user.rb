# frozen_string_literal: true

class User < ApplicationRecord
  ROLES = %w[admin client collaborator].freeze

  devise :database_authenticatable, :validatable

  has_one :client, dependent: :nullify
  has_one :employee, dependent: :nullify

  before_save :ensure_auth_token

  validates :role, inclusion: { in: ROLES }

  def admin?
    role == "admin"
  end

  def client?
    role == "client"
  end

  def collaborator?
    role == "collaborator"
  end

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
