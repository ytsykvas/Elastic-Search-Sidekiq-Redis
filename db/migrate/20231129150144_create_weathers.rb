# frozen_string_literal: true

class CreateWeathers < ActiveRecord::Migration[7.1]
  def change
    create_table :weathers do |t|
      t.date :current_date
      t.decimal :current_temperature, precision: 3, scale: 1
      t.decimal :temperature_last_year, precision: 3, scale: 1
      t.decimal :temperature_difference, precision: 3, scale: 1

      t.timestamps
    end
  end
end
