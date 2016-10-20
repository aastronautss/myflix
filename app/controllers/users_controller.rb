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

    if @user.save
      process_invite
      flash[:success] = "Registration successful! You may now sign in."
      AppMailer.send_welcome_email(@user).deliver
      redirect_to login_path
    else
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit :email, :password, :full_name
  end

  def invite_token_given?
    !params[:invite_token].nil?
  end

  def process_invite
    if invite_token_given?
      @invite = Invite.find_by token: params[:invite_token]
      set_followings
      expire_token
    end
  end

  def set_followings
    inviter = @invite.inviter

    inviter.follow @user
    @user.follow inviter
  end

  def expire_token
    @invite.expire_token
  end
end
