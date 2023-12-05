# frozen_string_literal: true

class Weather < ApplicationRecord
  validates :current_date, presence: true
  validates :current_temperature,
            numericality: { greater_than_or_equal_to: -100, less_than_or_equal_to: 100, precision: 1 }
  validates :temperature_last_year,
            numericality: { greater_than_or_equal_to: -100, less_than_or_equal_to: 100, precision: 1 }
  validates :temperature_difference,
            numericality: { greater_than_or_equal_to: -100, less_than_or_equal_to: 100, precision: 1 }
end
