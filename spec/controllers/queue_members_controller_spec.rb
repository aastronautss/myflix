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


  describe 'POST create' do
    let(:video) { Fabricate :video }

    context 'when not logged in' do
      before(:each) do
        session[:user_id] = nil
        post :create, id: video.id
      end

      it 'redirects to root path' do
        expect(response).to redirect_to(root_path)
      end
    end

    context 'when logged in' do
      let(:current_user) { Fabricate :user }
      before(:each) do
        session[:user_id] = current_user.id
        @action = -> { post :create, id: video.id }
      end

      context "when video doesn't exist in queue" do
        it 'creates a new QueueMember record' do
          expect{ @action.call }.to change{ QueueMember.all.length }.by(1)
        end

        it 'associates the record to the current user' do
          expect{ @action.call }.to change{ current_user.reload.queue_members.length }.by(1)
        end

        it 'redirects to my_queue path' do
          @action.call
          expect(response).to redirect_to(my_queue_path)
        end
      end

      context 'when video exists in queue' do
        before(:each) { current_user.add_to_queue video }

        it 'does not create a record' do
          expect{ @action.call }.to change{ QueueMember.all.length }.by(0)
        end

        it 'redirects back to the video show page' do
          @action.call
          expect(response).to redirect_to(video)
        end
      end
    end
  end
end
