# frozen_string_literal: true

class WeatherWorker
  include Sidekiq::Job

  def perform
    last_temperature = temperature_last_year
    current_temperature = process_current_temperature
    params = {
      last_temperature:,
      current_temperature:
    }

    create_weather(params)
  end

  private

  def temperature_last_year
    ::Weather::GetWeather.new('last_weather').perform
  end

  def process_current_temperature
    ::Weather::GetWeather.new('current_weather').perform
  end

  def create_weather(params)
    ::Weather::CreateWeather.new(params).perform
  end
end
