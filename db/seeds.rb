# frozen_string_literal: true

# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

require 'faker'

100.times do
  Customer.create(
    full_name: Faker::Name.name,
    age: Faker::Number.between(from: 18, to: 99),
    email: Faker::Internet.email,
    country: Faker::Address.country,
    balance: Faker::Number.decimal(l_digits: 2)
  )
end
