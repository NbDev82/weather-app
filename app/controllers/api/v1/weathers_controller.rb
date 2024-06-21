require_relative '../../../service/weather_service'

require 'date'

class Api::V1::WeathersController < ApplicationController
  before_action :set_location, :set_key, :set_day_for_forecast, only: [:get_weather, :get_forecast_weather, :get_history, :get_location]

  def get_weather
    begin
      if @location.nil? || @location == ""
        raise "You must type your city previously!"
      end

      @weather_service = WeatherService.new(@key,@days)
      current_hour = Time.now.hour

      weather_response = @weather_service.forecast_weather(@location, current_hour, nil)

      render json: weather_response, status: 200
    rescue => e
      render json: { error: e.message }, status: 500
    end
  end

  def get_forecast_weather
    begin
      quantity =  params[:quantity].to_i

      if quantity.nil? || quantity <= 0
        raise "You must search previously!"
      end

      if quantity >=13
        raise "Can't forecast over 14 days!"
      end

      if quantity % 4 != 0
        raise "Some error occur, please reload page!"
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
      if @location.nil? || @location == ""
        raise "You must type your city previously!"
      end

      @weather_service = WeatherService.new(@key,@days)

      time = Time.now
      formatted_date = time.strftime('%Y-%m-%d')

      weather_response = @weather_service.get_history(@location, formatted_date)
      weather_history = weather_response.forecast_weathers

      render json: weather_history
    rescue => e
      render json: { error: e.message }, status: 500
    end
  end

  def get_location
    begin
      if params[:ip].nil? || params[:ip] == ""
        raise "Can't find your IP!"
      end

      @weather_service = WeatherService.new(@key,@days)
      ip = params[:ip]

      location_response = @weather_service.get_location(ip)
      render json: location_response['city'], status: 200
    rescue => e
      render json: { error: e.message }, status: 500
    end
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
