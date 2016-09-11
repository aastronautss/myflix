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

  describe 'DELETE destroy' do
    let(:video) { Fabricate :video }

    context 'when not logged in' do
      it 'redirects to root path' do
        current_user = Fabricate :user
        mem = current_user.add_to_queue video
        delete :destroy, id: mem.id

        expect(response).to redirect_to(root_path)
      end
    end

    context 'when logged in as the incorrect user' do
      let(:current_user) { Fabricate :user }
      let(:queue_owner) { Fabricate :user }
      before(:each) do
        session[:user_id] = current_user.id
        member = queue_owner.add_to_queue video
        @action = -> { delete :destroy, id: member.id }
      end

      it 'does not delete the QueueMember record' do
        expect{ @action.call }.to change{ QueueMember.all.length }.by(0)
      end
    end

    context 'when logged in' do
      let(:current_user) { Fabricate :user }
      before(:each) do
        session[:user_id] = current_user.id
        member = current_user.add_to_queue video
        @action = -> { delete :destroy, id: member.id }
      end

      context 'on valid delete' do
        it 'destroys QueueMember record' do
          expect{ @action.call }.to change{ QueueMember.all.length }.by(-1)
        end

        it 'redirects to my_queue path' do
          @action.call
          expect(response).to redirect_to(my_queue_path)
        end
      end
    end
  end

  describe 'POST update_queue' do
    context 'when not logged in' do
      it 'redirets to root path' do
        post :update_queue, queue_members: [ { id: 1, position: 1 } ]
        expect(response).to redirect_to(root_path)
      end
    end

    context 'when logged in' do
      let(:user) { Fabricate :user }
      let(:videos) { Fabricate.times 3, :video }
      let(:queue_members) { videos.map { |video| user.add_to_queue video } }

      before(:each) { session[:user_id] = user.id }

      context 'with no committed changes' do
        let(:action) do
          lambda do
           post :update_queue,
             queue_members: queue_members.map { |m| { id: m.id, position: m.list_order } }
          end
        end

        it 'does not change any queue members' do
          expect{ action.call }.to_not change(user, :queue_members)
        end

        it 'redirects to my_queue path' do
          action.call
          expect(response).to redirect_to(my_queue_path)
        end
      end

      context 'with committed changes in the correct sequence' do
        let(:action) do
          lambda do
            post :update_queue,
              queue_members: [ { id: queue_members[0].id, position: 2 },
                               { id: queue_members[1].id, position: 1 },
                               { id: queue_members[2].id, position: 3 } ]
          end
        end

        # Not a very well-written test case, but it works.
        it 'updates the appropriate queue members' do
          action.call
          # binding.pry
          expect(user.queue_members.map(&:id)).to eq([ queue_members[1].id,
                                                       queue_members[0].id,
                                                       queue_members[2].id ])
        end

        it 'redirects to my_queue path' do
          action.call
          expect(response).to redirect_to(my_queue_path)
        end
      end

      context 'with sparsely commited changes' do
        let(:action) do
          lambda do
            post :update_queue,
              queue_members: [ { id: queue_members[0].id, position: 1 },
                               { id: queue_members[1].id, position: 2 },
                               { id: queue_members[2].id, position: 4 } ]
          end
        end

        it 'adjusts the order so everything is in sequence' do
          action.call
          expect(user.queue_members.map(&:list_order)).to eq([1, 2, 3])
        end

        it 'redirects to my_queue path' do
          action.call
          expect(response).to redirect_to(my_queue_path)
        end
      end

      context 'with densely commited changes' do
        let(:action) do
          lambda do
            post :update_queue,
              queue_members: [ { id: queue_members[0].id, position: 1 },
                               { id: queue_members[1].id, position: 1 },
                               { id: queue_members[2].id, position: 2 } ]
          end
        end

        it 'adjusts the order so everything is in sequence' do
          action.call
          expect(user.queue_members.map(&:list_order)).to eq([1, 2, 3])
        end

        it 'redirects to my_queue path' do
          action.call
          expect(response).to redirect_to(my_queue_path)
        end
      end
    end
  end
end
