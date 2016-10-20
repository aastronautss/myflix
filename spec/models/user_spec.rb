require 'spec_helper'

describe User do
  context 'associations' do
    it do
      should have_many(:reviews).
        dependent(:destroy).
        order('created_at desc')
    end

    it do
      should have_many(:queue_members).
      dependent(:destroy).
      order('list_order asc')
    end

    # ====-----------------------====
    # Followings
    # ====-----------------------====

    it do
      should have_many(:active_followings).
        dependent(:destroy).
        class_name('Following').
        with_foreign_key('follower_id')
    end

    it do
      should have_many(:followed_users).
        through(:active_followings).
        source(:followed)
    end

    it do
      should have_many(:followers).
        through(:passive_followings).
        source(:follower)
    end

    # ====-----------------------====
    # Invites
    # ====-----------------------====

    it do
      should have_many(:invitees).
        through(:outgoing_invites).
        source(:invitee)
    end

    it do
      should have_one(:inviter).
        through(:incoming_invite).
        source(:inviter)
    end
  end

  context 'validations' do
    it { should have_secure_password }

    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:full_name) }
    it { should validate_presence_of(:password) }

    it { should validate_uniqueness_of(:email) }

    it do
      should validate_length_of(:password).
        is_at_least(5).is_at_most(30)
    end
    it do
      should validate_length_of(:full_name).
        is_at_least(2)
    end
  end

  describe '#add_to_queue' do
    let(:user) { Fabricate :user }
    let(:vid_1) { Fabricate :video }
    let(:vid_2) { Fabricate :video }

    before(:each) do
      @action = -> (vid) { user.add_to_queue vid }
    end

    context 'with valid input' do
      context 'when adding one member' do
        it 'creates a new QueueMember record' do
          expect{ @action.call vid_1 }.to change{ QueueMember.all.length }.by(1)
        end

        it 'associates the new record with the user' do
          expect{ @action.call vid_1 }.to change{ user.queue_members.length }.by(1)
        end

        it 'returns the created QueueMember record' do
          expect(@action.call vid_1).to eq(QueueMember.last)
        end
      end

      context 'when adding multiple members' do
        it 'creates multiple QueueMember records' do
          expect do
            @action.call vid_1
            @action.call vid_2
          end.to change{ QueueMember.all.length }.by(2)
        end

        it 'associates records with the user' do
          expect do
            @action.call vid_1
            @action.call vid_2
          end.to change{ user.queue_members.length }.by(2)
        end
      end
    end

    context 'with invalid input' do
      it 'returns false' do
        @action.call vid_1
        expect(@action.call vid_1).to be(false)
      end
    end
  end

  describe '#has_video_in_queue?' do
    let(:user) { Fabricate :user }
    let(:video) { Fabricate :video }

    context 'with video in queue' do
      it 'returns true' do
        user.add_to_queue video
        expect(user.has_video_in_queue? video).to be(true)
      end
    end

    context 'without video in queue' do
      it 'returns false' do
        expect(user.has_video_in_queue? video).to be(false)
      end
    end
  end

  describe '#follow' do
    let(:user) { Fabricate :user }
    let(:other_user) { Fabricate :user }
    let(:action) { user.follow other_user }

    context 'when user is not following other user' do
      it 'creates a Following record' do
        expect{ action }.to change(Following, :count).by(1)
      end

      it 'associates the Following record appropriately' do
        action
        new_record = Following.last
        expect(new_record.follower).to eq(user)
        expect(new_record.followed).to eq(other_user)
      end

      it 'returns the Following record' do
        expect(action).to eq(Following.last)
      end
    end

    context 'when user is already following other user' do
      before { user.follow other_user }

      it 'does not create a Following record' do
        expect{ action }.to change(Following, :count).by(0)
      end

      it 'returns false' do
        expect(action).to be(false)
      end
    end
  end

  describe '#is_following?' do
    let(:user) { Fabricate :user }
    let(:other_user) { Fabricate :user }
    let(:action) { user.is_following? other_user }

    context 'when user is following other user' do
      it 'returns true' do
        user.follow other_user
        expect(action).to be(true)
      end
    end

    context 'when user is not following other user' do
      it 'returns false' do
        expect(action).to be(false)
      end
    end
  end

  describe '#generate_reset_token' do
    let(:user) { Fabricate :user }
    let(:action) { user.generate_reset_token }

    it 'sets the user\'s reset token' do
      action
      expect(user.reset_token).to be_present
    end
  end

  describe '#expire_reset_token' do
    let(:user) { Fabricate :user }
    let(:action) { user.expire_reset_token }

    before { user.generate_reset_token }

    it 'clears the user\'s reset token' do
      action
      expect(user.reset_token).to be_nil
    end
  end

  describe '#token_expired?' do
    let(:user) { Fabricate :user }
    let(:action) { user.token_expired? }

    context 'when token is not expired' do
      before { user.generate_reset_token }
    end
  end
end
