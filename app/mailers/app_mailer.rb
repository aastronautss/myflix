class AppMailer < ActionMailer::Base
  def send_welcome_email(user)
    @user = user

    mail to: user.email,
      from: 'info@myflix.com',
      subject: 'Welcome to MyFlix!'
  end

  def send_forgot_password_email(user)
    @user = user

    mail to: user.email,
      from: 'info@myflix.com',
      subject: 'MyFlix Password Reset'
  end
end