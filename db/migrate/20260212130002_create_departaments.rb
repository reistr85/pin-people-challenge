# frozen_string_literal: true

class CreateDepartaments < ActiveRecord::Migration[8.1]
  def change
    create_table :departaments do |t|
      t.uuid :uuid, default: "gen_random_uuid()", null: false
      t.string :name, limit: 100

      t.timestamps
      t.datetime :deleted_at
    end

    add_index :departaments, :uuid
    add_index :departaments, :deleted_at
  end
end
