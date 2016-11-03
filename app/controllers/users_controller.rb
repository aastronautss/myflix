class UsersController < ApplicationController
  before_action :require_logged_out, only: [:new, :new_with_invitation, :create]
  before_action :require_user, only: [:show]

  def show
    @user = User.find params[:id]
  end

  def new
    @user = User.new
  end

  def new_with_invitation
    @invite_token = params[:token]
    invite = Invite.find_by token: @invite_token
    if invite
      @user = User.new email: invite.email, full_name: invite.name, inviter: invite.inviter
      render :new
    else
      redirect_to invalid_token_path
    end
  end

  def create
    @user = User.new user_params
    result = UserSignup.new(@user).sign_up(params[:stripeToken], params[:invite_token])

    if result.successful?
      flash[:success] = 'Registration successful! You may now sign in.'
      redirect_to login_path
    else
      flash[:danger] = result.message
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit :email, :password, :full_name
  end
end
