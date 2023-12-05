# frozen_string_literal: true

class Task < ApplicationRecord
  validates :name, presence: true, length: { minimum: 3 }
  validates :description, presence: true, length: { minimum: 10 }
  validates :status, inclusion: { in: %w[TO DO DONE OVERDUE] }
  validates :due_date, presence: true
end
