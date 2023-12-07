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
    Customers::CacheCustomers.new.fetch_cached_customers
  end
end
