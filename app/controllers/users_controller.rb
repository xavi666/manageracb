class UsersController < ApplicationController
  before_action :require_authentication, only: [:show]
  layout "front"

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      cookies[:auth_token] = @user.auth_token
      redirect_to root_path, success: 'Gracias por registrarte!'
    else
      render :new
    end
  end

  def show
    @user = User.where(id: params[:id]).first
  end

  private

  def user_params
    params.require(:user).permit(
      :name,
      :email,
      :password,
      :password_confirmation
    )
  end

end
