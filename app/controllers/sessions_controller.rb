class SessionsController < ApplicationController
  def new
  end

  def create
    email = signin_params[:email]
    password = signin_params[:password]
    user = User.find_by(email: email)
    if user && user.authenticate(password)
      sign_in(user)
      redirect_to current_user
    else
      flash.now[:danger] = I18n.t('message.invalid_signin')
      render 'new'
    end
  end

  def destroy
    signed_out
    redirect_to root_url
  end

  private

  def signin_params
    params.require(:session).permit(:email, :password)
  end

end
