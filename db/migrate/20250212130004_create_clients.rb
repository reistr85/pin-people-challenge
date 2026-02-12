# frozen_string_literal: true

class CreateClients < ActiveRecord::Migration[8.1]
  def change
    create_table :clients do |t|
      t.uuid :uuid
      t.string :name, limit: 100
      t.string :email, limit: 100

      t.timestamps
      t.datetime :deleted_at
    end

    add_index :clients, :uuid
    add_index :clients, :email
    add_index :clients, :deleted_at
  end
end
