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
      context 'with valid password' do
        let(:action) { post :create, id: user.reset_token, password: 'changed' }

        it 'changes the password' do
          expect{ action }.to change{ user.reload.password_digest }
        end

        it 'sets the flash' do
          action
          expect(flash[:success]).to be_present
        end

        it 'redirects to login path' do
          action
          expect(response).to redirect_to(login_path)
        end
      end

      # context 'with invalid password' do
      #   let(:action) { post :create, id: user.reset_token, password: '' }

      #   it 'does not change the password' do
      #     expect{ action }.to_not change{ user.reload.password_digest }
      #   end

      #   it 'sets the flash' do
      #     action
      #     expect(flash[:danger]).to be_present
      #   end

      #   it 'redirects to password reset path' do
      #     action
      #     expect(response).to redirect_to(password_reset_path(user.reset_token))
      #   end
      # end
    end

    context 'when token has expired' do
      before do
        @token = user.reset_token
        user.expire_reset_token
      end
      let(:action) { post :create, id: @token, password: '' }

      it 'does not change the password' do
        expect{ action }.to_not change{ user.reload.password_digest }
      end

      it 'redirects to invalid token path' do
        action
        expect(response).to redirect_to(invalid_token_path)
      end
    end
  end
end
