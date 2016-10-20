require 'spec_helper'

describe InvitesController do
  describe 'GET new' do
    let(:action) { get :new }
    before { set_user }

    it_behaves_like 'a private action'

    it 'sets @invite' do
      action
      expect(assigns(:invite)).to be_instance_of(Invite)
      expect(assigns(:invite)).to be_new_record
    end
  end

  describe 'POST create' do
    let(:user) { Fabricate :user }
    let(:action) do
      post :create,
      invite: Fabricate.attributes_for(:invite, inviter: user, email: 'example@example.com')
    end

    before { set_user user }
    after { ActionMailer::Base.deliveries.clear }

    it_behaves_like 'a private action'

    it 'sets @invite' do
      action
      expect(assigns(:invite)).to be_instance_of(Invite)
    end

    context 'with valid input' do
      it 'creates an Invite record' do
        expect{ action }.to change(Invite, :count).by(1)
      end

      it 'sends an email to the invitee' do
        action
        expect(ActionMailer::Base.deliveries.last.to).to eq(['example@example.com'])
      end

      it 'sets the flash' do
        action
        expect(flash[:success]).to be_present
      end

      it 'redirects to invite page' do
        action
        expect(response).to redirect_to(invite_path)
      end
    end

    context 'with invalid input' do
      let(:action) do
        post :create,
          invite: Fabricate.attributes_for(:invite, inviter: user, name: '')
      end

      it 'does not create an Invite record' do
        expect{ action }.to change(Invite, :count).by(0)
      end

      it 'does not send an email to the invitee' do
        action
        expect(ActionMailer::Base.deliveries).to be_empty
      end

      it 'renders :new' do
        action
        expect(response).to render_template(:new)
      end
    end
  end
end
