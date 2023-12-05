# frozen_string_literal: true

module Customers
  class CustomerStatistic
    def initialize(customers)
      @customers = customers
    end

    def perform
      result = {
        longest_names: longest_names,
        popular_countries: popular_countries,
        richest_customers: richest_customers
      }
    end

    private

    def longest_names
      full_names = @customers.map { |customer| customer["full_name"] }.sort_by { |name| name.length }.reverse.first(10)
      name_length_array = full_names.map { |name| [name, name.length] }
      name_length_hash = name_length_array.to_h
    end

    def popular_countries
      country_counts = Hash.new(0)
      @customers.each do |customer|
        country_counts[customer["country"]] += 1
      end
      top_countries = country_counts.sort_by { |_, count| -count }.to_h.first(10).to_h
    end

    def richest_customers
      # binding.irb
      top_customers = @customers.sort_by { |customer| -customer["balance"].to_f }.first(10)
      result_hash = top_customers.map! { |customer| { customer["full_name"] => customer["balance"] } }
    end
  end
end
