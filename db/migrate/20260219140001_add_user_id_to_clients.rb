# frozen_string_literal: true

class AddUserIdToClients < ActiveRecord::Migration[8.1]
  def change
    return if column_exists?(:clients, :user_id)

    add_reference :clients, :user, null: true, foreign_key: true
  end
end
