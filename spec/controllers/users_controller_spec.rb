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
      context 'with valid input' do
        before(:each) { post :create, user: Fabricate.attributes_for(:user) }

        it 'creates the user' do
          expect(User.count).to eq(1)
        end

        it 'redirects to the sign in page' do
          expect(response).to redirect_to(login_path)
        end

        context 'sending email' do
          it 'sends out the email' do
            deliveries = ActionMailer::Base.deliveries
            expect(deliveries).to_not be_empty
          end

          it 'sends to the right recipient' do
            message = ActionMailer::Base.deliveries.last
            expect(message.to).to include(User.first.email)
          end

          it 'has the right content' do
            message = ActionMailer::Base.deliveries.last
            expect(message.body).to include(User.first.full_name)
          end
        end

        context 'with invite token given' do
          let(:inviter) { Fabricate :user }
          before(:each) { post :create, user: Fabricate.attributes_for(:user), invite_token: Fabricate(:invite, inviter: inviter).token }

          it 'sets the inviter as following the invitee' do
            invitee = User.last
            expect(inviter.is_following? invitee).to be(true)
          end

          it 'sets the invitee as following the inviter' do
            invitee = User.last
            expect(invitee.is_following? inviter).to be(true)
          end

          it 'expires the token' do
            expect(Invite.first.reload.token).to be_nil
          end
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
