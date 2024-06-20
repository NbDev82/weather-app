# frozen_string_literal: true

class WeatherService
  include HTTParty
  base_uri 'https://api.weatherapi.com/v1'

  def initialize(api_key, days)
    @api_key = api_key
    @days = days
  end

  def query_api(location, hour)
    query_params = { key: @api_key,
                     days: @days,
                     q: location}

    query_params[:hour] = hour if hour

    response = self.class.get("/forecast.json", query: query_params)

    handle_response(response)
  end

  def forecast_weather(location, hour, quantity)
    response = query_api(location, hour)

    unless quantity
      weather = create_current_weather(response)
      weather_saved = Weather
                        .where("location LIKE ?", "%#{location}%")
                        .where(date: weather.date)
                        .first

      if weather_saved
        fields_to_update = [:date, :temperature, :wind, :humidity, :condition, :url_img, :updated_at]
        update_values = weather.attributes.slice(*fields_to_update)
        update_values[:updated_at] = Time.now

        weather_saved.update(update_values)
      else
        weather.save!
      end
    end

      forecast_weathers = get_forecast_weather_in_next_4_days(response, quantity)
      WeatherResponse.new(weather, forecast_weathers)
  end

  private

  def handle_response(response)
    if response.success?
      response
    else
      { error: response['error'] || 'Unable to fetch weather information' }
    end
  end

  def create_forecast_weather(weather_data)
    date = weather_data['date']
    temperature = "#{weather_data['day']['mintemp_c']}°C" +'-' + "#{weather_data['day']['maxtemp_c']}°C"

    wind_kph = weather_data['day']['maxwind_kph']
    wind_m_s = (wind_kph / 3.6).round(2)
    wind = "#{wind_m_s} M/S"

    humidity = "#{weather_data['day']['avghumidity']}%"
    condition = weather_data['day']['condition']['text']
    url_img = "https:#{weather_data['day']['condition']['icon']}"

    Weather.new(
      date: date,
      temperature: temperature,
      wind: wind,
      humidity: humidity,
      condition: condition,
      url_img: url_img
    )
  end

  def create_current_weather(weather_data)

    location = weather_data['location']['name']
    date = weather_data['current']['last_updated']
    temperature = "#{weather_data['current']['temp_c']}°C"

    wind_kph = weather_data['current']['wind_kph']
    wind_m_s = (wind_kph / 3.6).round(2)
    wind = "#{wind_m_s} M/S"

    humidity = "#{weather_data['current']['humidity']}%"
    condition = weather_data['current']['condition']['text']
    url_img = "https:#{weather_data['current']['condition']['icon']}"

    Weather.new(
      location: location,
      date: date,
      temperature: temperature,
      wind: wind,
      humidity: humidity,
      condition: condition,
      url_img: url_img
    )
  end

  def get_forecast_weather_in_next_4_days(weather_data, quantity)
    forecast_weathers = []
    forecast_days = weather_data['forecast']['forecastday']

    quantity_for_drop = quantity.nil? ? 1 : quantity + 1

    forecast_days.drop(quantity_for_drop).each do |forecastday|
      forecast_weather = create_forecast_weather(forecastday)
      forecast_weathers << forecast_weather
    end

    forecast_weathers
  end

end
