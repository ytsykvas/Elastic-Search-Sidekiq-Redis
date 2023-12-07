# frozen_string_literal: true

module Customers
  class cached_customers
    def initialize
      @cache_key = 'customers_cache_key'
    end

    def fetch_cached_customers
      cached_customers = Rails.cache.read(@cache_key)

      unless cached_customers
        puts 'Cache miss. Loading customers from the database.'
        cached_customers = Customer.all
        Rails.cache.write(@cache_key, cached_customers, expires_in: 1.hour)
      else
        puts 'Cache hit. Loading customers from the cache.'
        cached_customers = JSON.parse(cached_customers)
      end

      cached_customers
    end
  end
end
