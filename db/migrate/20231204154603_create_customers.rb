# frozen_string_literal: true

class CreateCustomers < ActiveRecord::Migration[7.1]
  def change
    create_table :customers do |t|
      t.string :full_name, null: false
      t.integer :age, null: false
      t.string :email, null: false
      t.string :country, null: false
      t.decimal :balance, null: false

      t.timestamps
    end
  end
end
