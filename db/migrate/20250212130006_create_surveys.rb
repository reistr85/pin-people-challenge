# frozen_string_literal: true

class CreateSurveys < ActiveRecord::Migration[8.1]
  def change
    create_table :surveys do |t|
      t.references :client, null: true, foreign_key: true

      t.uuid :uuid
      t.string :name, limit: 100
      t.text :description

      t.timestamps
      t.datetime :deleted_at
    end

    add_index :surveys, :uuid
    add_index :surveys, :deleted_at
  end
end
