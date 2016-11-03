require 'spec_helper'

describe UsersController do
  describe 'GET show' do
    let(:user) { Fabricate :user }
    let(:action) { get :show, id: user.id }
    before { set_user }

    it_behaves_like 'a private action'

    it 'sets @user' do
      action
      expect(assigns(:user)).to eq(user)
    end

    it 'renders :show' do
      action
      expect(response).to render_template(:show)
    end
  end

  describe 'GET new' do
    context 'when logged out' do
      before(:each) do
        session[:user_id] = nil
        get :new
      end

      it 'sets a new @user variable' do
        expect(assigns(:user)).to be_new_record
        expect(assigns(:user)).to be_instance_of(User)
      end
    end

    context 'when logged in' do
      before(:each) do
        session[:user_id] = Fabricate(:user).id
        get :new
      end

      it 'redirects to root' do
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe 'GET new_with_invitation' do
    context 'when logged out' do
      let(:user) { Fabricate :user }
      let(:invite) { Fabricate :invite, inviter: user }

      before(:each) do
        session[:user_id] = nil
        get :new_with_invitation, token: invite.token
      end

      it 'sets @invite_token' do
        expect(assigns(:invite_token)).to be_present
      end

      it 'sets @user' do
        expect(assigns(:user)).to be_instance_of(User)
      end

      it 'autofills @user\'s attributes' do
        expect(assigns(:user).email).to eq(invite.email)
        expect(assigns(:user).full_name).to eq(invite.name)
      end

      it 'renders :new' do
        expect(response).to render_template :new
      end
    end
  end

  describe 'POST create' do
    context 'when logged out' do
      let!(:stripe_token) { 'abc' }

      context 'with successful user signup' do
        it 'redirects to the sign in page' do
          result = double(:sign_up_result, successful?: true)
          expect_any_instance_of(UserSignup).to receive(:sign_up).and_return(result)

          post :create, user: Fabricate.attributes_for(:user)
          expect(response).to redirect_to(login_path)
        end
      end

      context 'with failed user signup' do
        before do
          result = double :sign_up_result,
            successful?: false,
            message: 'abcd'
          expect_any_instance_of(UserSignup).to receive(:sign_up).and_return(result)

          post :create, user: Fabricate.attributes_for(:user)
        end

        it 'renders :new' do
          expect(response).to render_template(:new)
        end

        it 'sets flash.now' do
          expect(flash.now[:danger]).to be_present
        end

        it 'sets @user' do
          expect(assigns(:user)).to be_instance_of(User)
        end
      end
    end
  end
end
