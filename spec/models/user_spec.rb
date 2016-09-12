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

  describe '#update_queue' do
    let(:user) { Fabricate :user }
    let(:videos) { Fabricate.times 3, :video }
    let(:queue_members) { videos.map { |video| user.add_to_queue video } }

    context 'with no committed changes' do
      let(:action) do
        lambda do
          queue_params = queue_members.map do |m|
            { id: m.id, position: m.list_order }
          end

          user.update_queue queue_params
        end
      end

      it 'does not change any queue members' do
        expect{ action.call }.to_not change(user, :queue_members)
      end
    end

    context 'with committed changes in the correct sequence' do
      let(:action) do
        lambda do
          queue_params = [ { id: queue_members[0].id, position: 2 },
                           { id: queue_members[1].id, position: 1 },
                           { id: queue_members[2].id, position: 3 } ]

          user.update_queue queue_params
        end
      end

      it 'updates the appropriate queue members' do
        action.call
        expect(user.queue_members.map(&:id)).to eq([ queue_members[1].id,
                                                     queue_members[0].id,
                                                     queue_members[2].id ])
      end
    end

    context 'with sparsely committed changes' do
      let(:action) do
        lambda do
          queue_params = [ { id: queue_members[0].id, position: 1 },
                           { id: queue_members[1].id, position: 2 },
                           { id: queue_members[2].id, position: 4 } ]

          user.update_queue queue_params
        end
      end

      it 'adjust the orders so everything is in sequence' do
        action.call
        expect(user.queue_members.map(&:list_order)).to eq([1, 2, 3])
      end
    end

    context 'with densely committed changes' do
      let(:action) do
        lambda do
          queue_params = [ { id: queue_members[0].id, position: 1 },
                           { id: queue_members[1].id, position: 1 },
                           { id: queue_members[2].id, position: 2 } ]

          user.update_queue queue_params
        end
      end

      it 'adjusts the order so everything is in sequence' do
        action.call
        expect(user.queue_members.map(&:list_order)).to eq([1, 2, 3])
      end
    end
  end
end
