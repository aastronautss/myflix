class PasswordResetsController < ApplicationController
  before_action :require_logged_out
  before_action :set_token_and_user
  before_action :require_unexpired_token

  def show
  end

  def create
    @user.password = params[:password]

    if @user.save
      flash[:success] = "Your password has been changed! You may now sign in."
      @user.expire_reset_token
      redirect_to login_path
    else
      flash[:danger] = "Something went wrong. You may have entered an invalid password."
      redirect_to password_reset_path(@token)
    end
  end

  private

  def set_token_and_user
    @token = params[:id]
    @user = User.find_by reset_token: @token
  end

  def require_unexpired_token
    redirect_to invalid_token_path unless @user
  end
end
