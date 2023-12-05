# frozen_string_literal: true

class CreateTasks < ActiveRecord::Migration[7.1]
  def change
    create_table :tasks do |t|
      t.string :name, null: false
      t.text :description
      t.date :due_date

      t.timestamps
    end
  end
end
