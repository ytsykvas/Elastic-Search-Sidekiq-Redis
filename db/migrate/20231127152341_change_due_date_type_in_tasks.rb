# frozen_string_literal: true

class ChangeDueDateTypeInTasks < ActiveRecord::Migration[7.1]
  def up
    change_column :tasks, :due_date, :datetime
  end

  def down
    change_column :tasks, :due_date, :date
  end
end
