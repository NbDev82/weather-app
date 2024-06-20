require_relative '../../../service/weather_service'

require 'date'

class Api::V1::WeathersController < ApplicationController
  before_action :set_location, :set_key, :set_day_for_forecast, only: [:get_weather, :get_forecast_weather, :get_history]

  def get_weather
    begin
      @weather_service = WeatherService.new(@key,@days)
      current_hour = Time.now.hour

      weather_response = @weather_service.forecast_weather(@location, current_hour, nil)

      render json: weather_response, status: 200
    rescue => e
      puts e.message
      render json: { error: e.message }, status: 500
    end
  end

  def get_forecast_weather
    begin
      quantity =  params[:quantity].to_i

      if quantity >=14
        raise "Can't forecast over 14 days!"
      end

      current_hour = Time.now.hour
      @days = @days + quantity

      @weather_service = WeatherService.new(@key,@days)

      weather_response = @weather_service.forecast_weather(@location, current_hour, quantity)

      render json: weather_response.forecast_weathers, status: 200
    rescue => e
      render json: { error: e.message }, status: 500
    end
  end

  def get_history
    begin
      @weather_service = WeatherService.new(@key,@days)

      time = Time.now
      formatted_date = time.strftime('%Y-%m-%d')

      weather_history = @weather_service.get_history(@location, formatted_date)

      render json: weather_history
    rescue => e
      render json: { error: e.message }, status: 500
    end
  end

  def location_params
    params.permit(:location)
  end

  private
  def set_day_for_forecast
    @days = 5
  end

  private
  def set_key
    @key = "9fcf175f71d948a188c63921242006"
  end

    def set_location
      @location = params[:location]
    rescue ActiveRecord::RecordNotFound
      render json: { message: "location not found" }, status: :not_found
    end
end
