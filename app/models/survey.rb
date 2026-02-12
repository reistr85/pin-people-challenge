# frozen_string_literal: true

class Survey < ApplicationRecord
  include SoftDeletable

  belongs_to :client, optional: true
  has_many :survey_questions, dependent: :destroy

  validates :name, length: { maximum: 100 }, allow_nil: true
end
