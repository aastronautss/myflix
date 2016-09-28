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
end
