class AccountActivationsController < ApplicationController
  def edit
    user = User.find_by(email: params[:email])
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.activate
      sign_in user
      flash[:success] = I18n.t('message.user_activated')
      redirect_to user
    else
      flash[:danger] = I18n.t('message.invalid_activation_url')
      redirect_to root_url
    end
  end
end
