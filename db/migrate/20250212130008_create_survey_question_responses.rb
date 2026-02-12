# frozen_string_literal: true

class CreateSurveyQuestionResponses < ActiveRecord::Migration[8.1]
  def change
    create_table :survey_question_responses do |t|
      t.references :survey_question, null: false, foreign_key: true
      t.references :employee, null: false, foreign_key: true

      t.uuid :uuid
      t.integer :value
      t.text :comment

      t.timestamps
      t.datetime :deleted_at
    end

    add_index :survey_question_responses, :uuid
    add_index :survey_question_responses, %i[survey_question_id employee_id],
              name: "index_survey_question_responses_on_question_and_employee"
    add_index :survey_question_responses, :deleted_at
  end
end