class CustomersController < ApplicationController
  before_action :load_cached_customers, only: [:index, :statistic]

  def index
    @customers = customers.paginate(page: params[:page], per_page: 20)
  end

  def statistic
    @statistic = Customers::CustomerStatistic.new(customers).perform
  end

  private

  def customers
    @cached_customers ||= load_cached_customers
  end

  def load_cached_customers
    cache_key = 'customers_cache_key'
    unless @cached_customers = Rails.cache.read(cache_key)
      puts 'Cache miss. Loading customers from the database.'
      @cached_customers = Customer.all
      Rails.cache.write(cache_key, @cached_customers, expires_in: 1.hour)
    else
      puts 'Cache hit. Loading customers from the cache.'
      @cached_customers = JSON.parse(@cached_customers)
    end
    @cached_customers
  end
end
