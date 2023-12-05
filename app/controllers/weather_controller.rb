# frozen_string_literal: true

class WeatherController < ApplicationController
  def index
    @weathers = Weather.all.paginate(page: params[:page], per_page: 15)
  end
end
