# frozen_string_literal: true

module Weather
  class CreateWeather
    def initialize(params)
      @params = params
    end

    def perform
      create_weather_record if valid_params?
    end

    private

    def create_weather_record
      Weather.create!(
        current_date: Time.now.to_date,
        current_temperature: @params[:current_temperature],
        temperature_last_year: @params[:last_temperature],
        temperature_difference:
      )
    end

    def temperature_difference
      (@params[:current_temperature].to_d - @params[:last_temperature].to_d).abs
    end

    def valid_params?
      true if validate_temperature_presence && validate_temperature_format
    end

    def validate_temperature_presence
      return false if temperature_blank?(@params[:current_temperature]) ||
                      temperature_blank?(@params[:last_temperature])

      true
    end

    def validate_temperature_format
      return false unless valid_decimal?(@params[:current_temperature]) &&
                          valid_decimal?(@params[:last_temperature])

      true
    end

    def temperature_blank?(value)
      value.blank?
    end

    def valid_decimal?(value)
      Float(value)
      true
    rescue ArgumentError
      false
    end
  end
end
