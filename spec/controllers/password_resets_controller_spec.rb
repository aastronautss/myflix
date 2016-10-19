require 'spec_helper'

describe PasswordResetsController do
  describe 'GET show' do
    let(:user) { Fabricate :user }
    before { user.generate_reset_token }

    context 'when token has not expired' do
      before do
        get :show, id: user.reset_token
      end

      it 'sets @token' do
        expect(assigns(:token)).to be_present
      end
    end

    context 'when token has expired' do
      before do
        token = user.reset_token
        user.expire_reset_token
        get :show, id: token
      end

      it 'redirects to invalid token page' do
        expect(response).to redirect_to(invalid_token_path)
      end
    end
  end

  describe 'POST create' do
    let(:user) { Fabricate :user }
    before { user.generate_reset_token }

    context 'when token has not expired' do
      before do
        post :create, token: user.reset_token, password: 'changed!'
      end

      it 'changes the user\'s password'

      it 'expires the user\'s reset token'

      it 'sets the flash'

      it 'redirects to login page'
    end
  end
end
