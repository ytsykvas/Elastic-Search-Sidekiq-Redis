# frozen_string_literal: true

module Customers
  class cached_customers
    def initialize
      @cache_key = 'customers_cache_key'
    end

    def fetch_cached_customers
      Customers::CacheCustomers.new.fetch_cached_customers
    end
  end
end
