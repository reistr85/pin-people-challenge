# frozen_string_literal: true

class CreateSurveyQuestions < ActiveRecord::Migration[8.1]
  def change
    create_table :survey_questions do |t|
      t.references :survey, null: false, foreign_key: true

      t.uuid :uuid, default: "gen_random_uuid()", null: false
      t.text :question

      t.timestamps
      t.datetime :deleted_at
    end

    add_index :survey_questions, :uuid
    add_index :survey_questions, :deleted_at
  end
end
