class ForgotPasswordsController < ApplicationController
  def create
    email = params[:email]
    user = User.find_by email: email

    if user
      user.generate_reset_token
      AppMailer.send_forgot_password_email(user).deliver
      redirect_to confirm_password_reset_path
    else
      flash[:danger] = email.empty? ? 'Email cannot be blank.' : 'Email not found.'
      redirect_to forgot_password_path
    end
  end
end
