class UserMailer < ApplicationMailer
  default from: 'phimrap748@gmail.com'

  def welcome_email(email)
    @url  = 'https://weather-api-app-ruby-ca24058ecac9.herokuapp.com'
    mail(to: email, subject: 'Welcome to My Weather Site')
  end

  def unsubscribed_email(email)
    @url  = 'https://weather-api-app-ruby-ca24058ecac9.herokuapp.com'
    mail(to: email, subject: 'Unsubscribed email')
  end

  def daily_summary_weather(user, weather_summary)
    @user = user
    @weather_summary = weather_summary
    @url  = 'https://weather-api-app-ruby-ca24058ecac9.herokuapp.com'
    mail(to: @user.email, subject: 'Daily Weather Summary')
  end

  # Sends daily weather summary emails to all users.
  #
  # This method iterates through each user in the database and sends an email
  # containing the daily weather summary. If the weather data for a user's email
  # address is not already cached in @weathers, it fetches the current weather
  # using a WeatherService instance and stores it in @weathers for future use.
  # The email is sent asynchronously using Active Job's `deliver_later` method.
  #
  # Returns:
  #   None
  def self.send_daily_weather_summary
    @weather_service = WeatherService.new("9fcf175f71d948a188c63921242006",1)
    hour_daily = 7
    @weathers=[]

    User.find_each do |user|
      @weather = @weathers.find(location: user.location)

      unless @weather
        weather_response = @weather_service.forecast_weather(@location, hour_daily, nil)
        @weather = weather_response.current_weather
        @weathers << @weather
      end

      daily_summary_weather(user, @weather).deliver_later
    end
  end
end
