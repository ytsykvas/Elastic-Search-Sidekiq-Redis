# frozen_string_literal: true

# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 20_231_204_154_603) do
  # These are extensions that must be enabled in order to support this database
  enable_extension 'plpgsql'

  create_table 'customers', force: :cascade do |t|
    t.string 'full_name', null: false
    t.integer 'age', null: false
    t.string 'email', null: false
    t.string 'country', null: false
    t.decimal 'balance', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  create_table 'tasks', force: :cascade do |t|
    t.string 'name', null: false
    t.text 'description'
    t.datetime 'due_date'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.string 'status', default: 'TO DO', null: false
  end

  create_table 'weathers', force: :cascade do |t|
    t.date 'current_date'
    t.decimal 'current_temperature', precision: 3, scale: 1
    t.decimal 'temperature_last_year', precision: 3, scale: 1
    t.decimal 'temperature_difference', precision: 3, scale: 1
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end
end
