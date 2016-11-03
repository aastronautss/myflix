class UserSignup
  attr_reader :message

  def initialize(user)
    @user = user
  end

  def sign_up(stripe_token, invite_token)
    if @user.valid?
      charge = StripeWrapper::Charge.create amount: 999,
        card: stripe_token,
        description: 'MyFlix membership charge'

      if charge.successful?
        @user.save
        process_invite(invite_token)

        AppMailer.delay.send_welcome_email(@user)
        @status = :success
      else
        @status = :failure
        @message = charge.message
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
