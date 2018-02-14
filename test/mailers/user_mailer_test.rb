require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  def setup
    @user = users(:michael)
  end

  test "account_activation" do
    @user.activation_token = User.new_token
    mail = UserMailer.account_activation(@user)
    assert_equal "ご登録ありがとうございます！アカウントを有効にしましょう。", mail.subject
    assert_equal [@user.email], mail.to
    assert_equal ["noreply@example.com"], mail.from
    assert_match @user.name, mail.body.encoded
    assert_match @user.activation_token, mail.body.encoded
    assert_match CGI.escape(@user.email), mail.body.encoded
  end

  test "password_reset" do
    @user.reset_token = User.new_token
    mail = UserMailer.password_reset(@user)
    assert_equal "パスワードの再設定", mail.subject
    assert_equal [@user.email], mail.to
    assert_equal ["noreply@example.com"], mail.from
    assert_match "To reset your password", mail.body.encoded
  end

end
