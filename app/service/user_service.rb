# frozen_string_literal: true

class UserService

  def register(email, location)
    user_saved = User.find_by(email: email)
    if user_saved
      raise "You have been registered previously!"
    end

    User.create!(email: email, location: location)
  end

  def unsubscribe(email)
    user_saved = User.find_by(email: email)
    if user_saved.nil?
      raise "You have not registered before!"
    end

    user_saved.destroy!
  end

end
