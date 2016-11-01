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

    if @user.valid?
      token = params[:stripeToken]
      charge = StripeWrapper::Charge.create amount: 999,
        card: token,
        description: 'MyFlix membership charge'

      if charge.successful?
        @user.save
        process_invite

        flash[:success] = 'Registration successful! You may now sign in.'
        AppMailer.delay.send_welcome_email(@user)
        redirect_to login_path
      else
        flash.now[:danger] = charge.message
        render :new
      end
    else
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit :email, :password, :full_name
  end

  def invite_token_given?
    !params[:invite_token].blank?
  end

  def process_invite
    if invite_token_given?
      @invite = Invite.find_by token: params[:invite_token]
      set_followings
      expire_token
    end
  end

  def process_payment
    begin
      charge = Stripe::Charge.create(
        :amount => 999,
        :currency => "usd",
        :source => token,
        :description => "Example charge"
      )
    rescue Stripe::CardError => e
      flash[:danger] = "There was a problem processing your payment: #{e.message}"
      redirect_to register_path
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
