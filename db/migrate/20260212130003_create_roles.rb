# frozen_string_literal: true

class CreateRoles < ActiveRecord::Migration[8.1]
  def change
    create_table :roles do |t|
      t.uuid :uuid, default: "gen_random_uuid()", null: false
      t.string :name, limit: 100

      t.timestamps
      t.datetime :deleted_at
    end

    add_index :roles, :uuid
    add_index :roles, :deleted_at
  end
end
