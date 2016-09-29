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

  describe 'POST create' do
    let(:other_user) { Fabricate :user }
    let(:action) { post :create, id: other_user.id }

    before { set_user }

    it_behaves_like 'a private action'

    it 'creates a Following record' do
      expect{ action }.to change(Following, :count).by(1)
    end

    it 'makes it so the logged in user is following the other user' do
      action
      expect(current_user.is_following? other_user).to be(true)
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

  describe 'DELETE destroy' do
    let(:other_user) { Fabricate :user }
    let(:action) { delete :destroy, id: other_user.id }

    before do
      set_user
      current_user.follow other_user
    end

    it_behaves_like 'a private action'

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
end
