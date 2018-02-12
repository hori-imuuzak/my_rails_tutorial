require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  def setup
    ActionMailer::Base.deliveries.clear
  end

  test "invalid signup information" do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, params: {
          user: {
              name: '',
              email: 'user@invalid.com',
              password: 'foo',
              password_confirm: 'foo',
          },
      }
    end
    assert_template 'users/new'
  end

  test "valid signup information with account activation" do
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, params: {
          user: {
              name: 'test',
              email: 'test@valid.com',
              password: 'hogehoge',
              password_confirm: 'hogehoge',
          },
      }
    end

    assert_equal 1, ActionMailer::Base.deliveries.size
    user = assigns(:user)
    assert_not user.activated?

    get edit_account_activation_path("invalid token", email: user.email)
    assert_not is_signed_in?

    get edit_account_activation_path(user.activation_token, email: "wrong email")
    assert_not is_signed_in?

    get edit_account_activation_path(user.activation_token, email: user.email)
    assert user.reload.activated?

    follow_redirect!
    assert_template 'users/show'
    assert_equal flash[:success], 'アカウントが有効になりました。'
    assert is_signed_in?
  end
end
