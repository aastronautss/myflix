require 'spec_helper'

describe QueueMembersController do
  describe 'GET index' do
    context 'when logged in' do
      it 'sets @queue_members to the queue members of current user' do
        alice = Fabricate :user
        session[:user_id] = alice.id
        vid_1 = Fabricate :video
        vid_2 = Fabricate :video

        member_1 = alice.add_to_queue vid_1
        member_2 = alice.add_to_queue vid_2

        get :index

        expect(assigns(:queue_members)).to match_array([member_1, member_2])
      end
    end

    context 'when logged out' do
      it 'redirects to root path' do
        get :index

        expect(response).to redirect_to(root_path)
      end
    end
  end
end
