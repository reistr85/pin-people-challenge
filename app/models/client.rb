# frozen_string_literal: true

class Client < ApplicationRecord
  include SoftDeletable

  belongs_to :user, optional: true
  has_many :employees, dependent: :nullify
  has_many :surveys, dependent: :nullify

  validates :name, length: { maximum: 100 }, allow_nil: true
  validates :email, length: { maximum: 100 }, allow_nil: true
end
