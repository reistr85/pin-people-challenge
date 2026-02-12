# frozen_string_literal: true

class Survey < ApplicationRecord
  include SoftDeletable

  def as_json(options = {})
    super(options.merge(except: [:client_id]))
  end

  belongs_to :client, optional: true
  has_many :survey_questions, dependent: :destroy

  validates :name, length: { maximum: 100 }, allow_nil: true
end
