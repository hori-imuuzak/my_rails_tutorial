module SessionsHelper
  def sign_in(user)
    session[:user_id] = user.id
  end

  def current_user
    if (user_id = session[:user_id])
      @current_user = User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.token_authenticated?(cookies[:remember_token])
        sign_in user
        @current_user = user
      end
    end
  end

  def signed_in?
    !current_user.nil?
  end

  def signed_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end

  def remember(user)
    user.remember
    cookies.signed[:user_id] = { value: user.id, expires: 1.month.from_now }
    cookies[:remember_token] = { value: user.remember_token, expires: 1.month.from_now }
  end

  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

end
