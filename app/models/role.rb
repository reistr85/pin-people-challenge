# frozen_string_literal: true

class Role < ApplicationRecord
  include SoftDeletable

  has_many :employees, dependent: :nullify

  validates :name, length: { maximum: 100 }, allow_nil: true
end
