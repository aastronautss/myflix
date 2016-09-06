require 'spec_helper'

describe UsersController do
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

  describe 'POST create' do
    context 'when logged out' do
      context 'with valid input' do
        before(:each) { post :create, user: Fabricate.attributes_for(:user) }

        it 'creates the user' do
          expect(User.count).to eq(1)
        end

        it 'redirects to the sign in page' do
          expect(response).to redirect_to(login_path)
        end
      end

      context 'with invalid input' do
        before(:each) do
          @user_info = { password: 'password',
                         full_name: Faker::Name.name }
          post :create, user: @user_info
        end

        it 'does not create a user' do
          expect(User.count).to eq(0)
        end

        it 'sets @user' do
          expect(assigns(:user)).to be_instance_of(User)
        end

        it 'renders the :new template' do
          expect(response).to render_template(:new)
        end
      end
    end
  end
end
