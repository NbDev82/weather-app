# frozen_string_literal: true

class WeatherResponse
  attr_accessor :current_weather, :forecast_weathers

  def initialize(current_weather, forecast_weathers)
    @current_weather = current_weather
    @forecast_weathers = forecast_weathers
  end

end
