# frozen_string_literal: true

class SurveyQuestion < ApplicationRecord
  include SoftDeletable

  belongs_to :survey
  has_many :survey_question_responses, dependent: :destroy

  validates :question, presence: true
end
