# frozen_string_literal: true

class WeatherService
  include HTTParty
  base_uri 'http://api.weatherapi.com/v1'

  def initialize(api_key)
    @api_key = api_key
  end

  def current_weather(location)
    response = self.class.get("/current.json", query: { key: @api_key, q: location, lang: 'vi' })
    handle_response(response)
  end

  private

  def handle_response(response)
    if response.success?
      response
    else
      { error: response['error'] || 'Unable to fetch weather information' }
    end
  end

end
