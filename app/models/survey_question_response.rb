# frozen_string_literal: true

class SurveyQuestionResponse < ApplicationRecord
  include SoftDeletable

  belongs_to :survey_question
  belongs_to :employee

  validates :value, numericality: { only_integer: true, allow_nil: true }, inclusion: { in: 0..10, message: "deve ser entre 0 e 10", allow_nil: true }
end
