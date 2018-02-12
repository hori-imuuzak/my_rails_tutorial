class UsersController < ApplicationController
  before_action :signed_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: [:destroy]

  def index
    @users = User.where(activated: true).paginate(page: params[:page], per_page: 10)
  end

  def show
    @user = User.find(params[:id])
    redirect_to root_url unless @user.activated
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = I18n.t 'message.please_activate'
      redirect_to root_url
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = I18n.t('message.profile_updated')
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find_by(id: params[:id]).destroy
    flash[:success] = I18n.t('message.user_destroyed')
    redirect_to users_url
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def signed_in_user
    unless signed_in?
      store_location
      flash[:danger] = I18n.t('message.please_sign_in')
      redirect_to signin_url
    end
  end

  def correct_user
    @user = User.find_by(id: params[:id])
    redirect_to root_url unless current_user?(@user)
  end

  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end
end
