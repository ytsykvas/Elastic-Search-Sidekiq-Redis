# frozen_string_literal: true

class AddStatusToTask < ActiveRecord::Migration[7.1]
  def change
    add_column :tasks, :status, :string, null: false, default: 'TO DO'
  end
end
