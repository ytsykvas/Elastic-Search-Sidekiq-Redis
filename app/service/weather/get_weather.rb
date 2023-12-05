# frozen_string_literal: true

require 'uri'
require 'net/http'

module Weather
  class GetWeather
    def initialize(param)
      @param = param
    end

    def perform
      response_data = make_api_request
      handle_response(response_data)
    end

    private

    def make_api_request
      http = Net::HTTP.new(request_url.host, request_url.port)
      http.use_ssl = true
      request = Net::HTTP::Get.new(request_url)
      request['X-RapidAPI-Key'] = ENV['WEATHER_API_KEY']
      request['X-RapidAPI-Host'] = ENV['WEATHER_API_HOST']
      JSON.parse(http.request(request).body, symbolize_names: true)
    end

    def handle_response(response_data)
      if response_data.key?(:error)
        raise StandardError, "API Error: #{response_data[:error][:message]}"
      elsif @param == 'last_weather'
        response_data[:data][:temp_c]
      else
        response_data[:current][:temp_c]
      end
    end

    def date
      date = Time.now.to_date - 1.year
      date.strftime('%Y-%m-%d')
    end

    def headers
      { content_type: :json, accept: :json, 'apikey' => ENV['WEATHER_API_KEY'] }
    end

    def request_url
      if @param == 'last_weather'
        URI("https://weatherapi-com.p.rapidapi.com/history.json?q=Lviv&dt=#{date}&lang=en")
      elsif @param == 'current_weather'
        URI('https://weatherapi-com.p.rapidapi.com/current.json?q=Lviv')
      else
        raise ArgumentError, "Invalid parameter. Allowed values are 'last_weather' or 'current_weather'."
      end
    end
  end
end
