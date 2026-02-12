# frozen_string_literal: true

class Employee < ApplicationRecord
  include SoftDeletable

  belongs_to :client, optional: true
  belongs_to :job_title, optional: true
  belongs_to :departament, optional: true
  belongs_to :role, optional: true

  has_many :survey_question_responses, dependent: :destroy

  validates :name, length: { maximum: 100 }, allow_nil: true
  validates :personal_email, length: { maximum: 100 }, allow_nil: true
  validates :corporation_email, length: { maximum: 100 }, allow_nil: true
  validates :uf, length: { maximum: 2 }, allow_nil: true
  validates :city, length: { maximum: 100 }, allow_nil: true
  validates :tenure, length: { maximum: 50 }, allow_nil: true
  validates :gender, length: { maximum: 10 }, allow_nil: true
end
