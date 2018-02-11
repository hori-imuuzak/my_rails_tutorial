require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...

  def is_signed_in?
    !session[:user_id].nil?
  end

  def sign_in_as(user)
    session[:user_id] = user.id
  end
end

class ActionDispatch::IntegrationTest
  def sign_in_as(user, password: 'password', remember_me: '1')
    post signin_path, params: {
        session: {
            email: user.email,
            password: password,
            remember_me: remember_me,
        }
    }
  end
end