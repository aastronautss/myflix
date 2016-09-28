require 'spec_helper'

describe User do
  context 'associations' do
    it { should have_many(:reviews).dependent(:destroy) }
    it { should have_many(:queue_members).dependent(:destroy).order('list_order asc') }
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
end
