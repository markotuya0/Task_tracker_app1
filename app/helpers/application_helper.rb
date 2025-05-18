module ApplicationHelper
  # Define fallback methods for Devise helpers during setup
  def user_signed_in?
    false
  end
  
  def current_user
    nil
  end
end