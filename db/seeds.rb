require 'faker'

def create_customers
  100.times do
    Customer.create(
      full_name: Faker::Name.name,
      age: Faker::Number.between(from: 18, to: 99),
      email: Faker::Internet.email,
      country: Faker::Address.country,
      balance: Faker::Number.decimal(l_digits: 2)
    )
  end
end

def create_books
  100.times do
    Book.create(
      title: Faker::Book.title,
      author: Faker::Book.author,
      published_year: Faker::Number.between(from: 1900, to: Date.today.year),
      excerpt: Faker::Lorem.paragraph(sentence_count: 2)
    )
  end
end

# use next command for seeding only one model
# SEED_BOOKS=true rails db:seed
# SEED_CUSTOMERS=true rails db:seed

create_books if ENV['SEED_BOOKS']
create_customers if ENV['SEED_CUSTOMERS']
