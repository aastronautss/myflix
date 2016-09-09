class UsersController < ApplicationController
  before_action :require_logged_out, only: [:new, :create]

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params

    if @user.save
      flash[:success] = "Registration successful! You may now sign in."
      redirect_to login_path
    else
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit :email, :password, :full_name
  end
end
