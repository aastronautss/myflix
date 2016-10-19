class PasswordResetsController < ApplicationController
  def show
    @token = params[:id]
    user = User.find_by reset_token: @token

    redirect_to invalid_token_path unless user
  end

  def create
    @token = params[:token]
    password = params[:password]

    user = User.find_by reset_token: @token

    user.password = password
    if user.save
      user.expire_reset_token
      flash[:success] = 'Your password has been changed! You may now log in.'
      redirect_to login_path
    else
      redirect_to invalid_token_path
    end
  end
end
