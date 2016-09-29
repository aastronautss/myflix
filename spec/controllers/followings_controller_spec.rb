require 'spec_helper'

describe FollowingsController do
  describe 'GET index' do
    let(:users) { Fabricate.times 2, :user }
    let(:action) { get :index }

    before do
      set_user
      users.each { |user| current_user.follow user }
    end

    it_behaves_like 'a private action'

    it 'sets @followed_users' do
      action
      expect(assigns(:followed_users)).to be_present
    end
  end

  describe 'DELETE destroy' do
    let(:other_user) { Fabricate :user }
    let(:action) do
      delete :destroy, id: Following.first.id
    end

    before do
      set_user
      current_user.follow other_user
    end

    it_behaves_like 'a private action'

    context 'when logged in as the follower' do
      it 'removes the Following record' do
        expect{ action }.to change(Following, :count).by(-1)
      end

      it 'makes it so the user is no longer following the other user' do
        action
        expect(current_user.is_following? other_user).to be(false)
      end

      it 'sets the flash' do
        action
        expect(flash[:success]).to be_present
      end

      it 'redirects to the people page' do
        action
        expect(response).to redirect_to(people_path)
      end
    end

    context 'when not logged in as the follower' do
      let(:unauthorized_user) { Fabricate :user }

      before do
        set_user unauthorized_user
      end

      it 'does not remove a Following record' do
        expect{ action }.to change(Following, :count).by(0)
      end

      it 'sets the flash' do
        action
        expect(flash[:danger]).to be_present
      end

      it 'redirects to root' do
        action
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
