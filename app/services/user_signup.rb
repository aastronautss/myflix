class UserSignup
  attr_reader :message

  def initialize(user)
    @user = user
  end

  def sign_up(stripe_token, invite_token)
    if @user.valid?
      customer = StripeWrapper::Customer.create card: stripe_token,
        user: @user

      if customer.successful?
        @user.stripe_customer_id = customer.id
        @user.save
        process_invite(invite_token)

        AppMailer.delay.send_welcome_email(@user)
        @status = :success
      else
        @status = :failure
        @message = customer.message
      end
    else
      @status = :failure
      @message = 'Invalid user information. Please check the errors below.'
    end

    self
  end

  def successful?
    @status == :success
  end

  private

  def process_invite(invite_token)
    if invite_token.present?
      invite = Invite.find_by token: invite_token
      set_followings(invite)
      invite.expire_token
    end
  end

  def set_followings(invite)
    inviter = invite.inviter

    inviter.follow @user
    @user.follow inviter
  end
end
