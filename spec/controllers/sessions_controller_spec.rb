require 'spec_helper'

describe SessionsController do
  describe 'GET new' do
    context 'when logged out' do
      it 'renders the :new template' do
        get :new
        expect(response).to render_template(:new)
      end
    end

    context 'when logged in' do
      it 'redirects to home page' do
        session[:user_id] = Fabricate(:user).id
        get :new
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe 'POST create' do
    context 'with valid credentials' do
      let(:alice) { Fabricate :user }
      before(:each) do
        post :create, email: alice.email, password: alice.password
      end

      it 'puts the signed in user in the session' do
        expect(session[:user_id]).to eq(alice.id)
      end

      it 'redirects to the home path' do
        expect(response).to redirect_to(home_path)
      end
    end

    context 'with invalid credentials' do
      let(:alice) { Fabricate :user }
      before(:each) do
        post :create, email: alice.email, password: alice.password + 'asdf'
      end

      it 'does not put the user into the session' do
        expect(session[:user_id]).to be_nil
      end

      it 'redirects to the signin page' do
        expect(response).to redirect_to(login_path)
      end

      it 'sets the error message' do
        expect(flash[:error]).to_not be_blank
      end
    end
  end

  describe 'GET destroy' do
    context 'when logged in' do
      before(:each) do
        session[:user_id] = Fabricate(:user).id
        get :destroy
      end

      it 'clears the session for the user' do
        expect(session[:user_id]).to be_nil
      end

      it 'redirects to the root path' do
        expect(response).to redirect_to(root_path)
      end

      it 'sets the notice' do
        expect(flash[:success]).to_not be_blank
      end
    end

    it_behaves_like 'a private action' do
      let(:action) { get :destroy }
    end
  end
end
