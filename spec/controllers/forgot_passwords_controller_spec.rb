require 'spec_helper'

describe ForgotPasswordsController do
  describe 'POST create' do
    context 'with blank input' do
      before { post :create, email: '' }

      it 'redirects to the forgot password page' do
        expect(response).to redirect_to(forgot_password_path)
      end

      it 'sets the flash' do
        expect(flash[:danger]).to be_present
      end
    end

    context 'with existing record' do
      let(:user) { Fabricate :user }
      before { post :create, email: user.email }

      it 'redirects to the forgot password confirmation page' do
        expect(response).to redirect_to(confirm_password_reset_path)
      end

      it 'sends an email to the email address' do
        expect(ActionMailer::Base.deliveries.last.to).to contain_exactly(user.email)
      end
    end

    context 'with non-existing record' do
      before { post :create, email: 'foo@bar.baz' }

      it 'redirects to forgot password page' do
        expect(response).to redirect_to(forgot_password_path)
      end

      it 'sets the flash' do
        expect(flash[:danger]).to be_present
      end
    end
  end
end
