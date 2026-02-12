# frozen_string_literal: true

class CreateJobTitles < ActiveRecord::Migration[8.1]
  def change
    create_table :job_titles do |t|
      t.uuid :uuid, default: "gen_random_uuid()", null: false
      t.string :name, limit: 100

      t.timestamps
      t.datetime :deleted_at
    end

    add_index :job_titles, :uuid
    add_index :job_titles, :deleted_at
  end
end
