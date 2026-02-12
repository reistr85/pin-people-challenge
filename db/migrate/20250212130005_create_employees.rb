# frozen_string_literal: true

class CreateEmployees < ActiveRecord::Migration[8.1]
  def change
    create_table :employees do |t|
      t.references :client, null: true, foreign_key: true
      t.references :job_title, null: true, foreign_key: true
      t.references :departament, null: true, foreign_key: true
      t.references :role, null: true, foreign_key: true

      t.uuid :uuid
      t.string :name, limit: 100
      t.string :personal_email, limit: 100
      t.string :corporation_email, limit: 100
      t.string :uf, limit: 2
      t.string :city, limit: 100
      t.string :tenure, limit: 50
      t.string :gender, limit: 10

      t.timestamps
      t.datetime :deleted_at
    end

    add_index :employees, :uuid
    add_index :employees, :corporation_email
    add_index :employees, :deleted_at
  end
end
