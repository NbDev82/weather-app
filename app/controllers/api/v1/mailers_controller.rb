require_relative '../../../service/user_service'

class Api::V1::MailersController < ApplicationController
  before_action :set_user_service, :set_email, only: [:register, :unsubscribe]
  before_action :set_location, only: [:register]

  def register
    begin
      @user_service.register(@email, @location)
      UserMailer.welcome_email(@email).deliver_now
      render json: {message: "You have been successfully registered."}
    rescue => e
      render json: {error: e.message}
    end
  end

  def unsubscribe
    begin
      @user_service.unsubscribe(@email)
      UserMailer.unsubscribed_email(@email).deliver_now
      render json: {message: "You have been successfully unsubscribed."}
    rescue => e
      render json: {error: e.message}
    end
  end

  private

  def set_user_service
    @user_service = UserService.new
  end

  private

  def set_email
    begin
      if params[:email].nil?
        raise "Email must both be provided"
      end

      @email  = params[:email]
    rescue => e
      render json: {error: e.message}, status: 500
    end
  end

  def set_location
    begin
      if params[:location].nil?
        raise "Location must both be provided"
      end

      @location = params[:location]
    rescue => e
      render json: {error: e.message}, status: 500
    end
  end
end
