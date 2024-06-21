class UserMailer < ApplicationMailer
  default from: 'phimrap748@gmail.com'

  def welcome_email(email)
    @url  = 'https://weather-api-app-ruby-ca24058ecac9.herokuapp.com'
    mail(to: email, subject: 'Welcome to My Weather Site')
  end
end
