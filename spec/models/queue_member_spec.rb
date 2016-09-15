require 'spec_helper'

describe QueueMember do
  context 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:video) }
  end

  context 'validations' do
    # it { should validate_presence_of(:user) }
    # it { should validate_presence_of(:video) }
    # it { should validate_presence_of(:list_order) }

    it { should validate_uniqueness_of(:video_id).scoped_to(:user_id) }

    it { should validate_numericality_of(:list_order).only_integer }
  end

  describe '#video_title' do
    it 'returns the title of the associated video' do
      user = Fabricate :user
      video = Fabricate :video
      queue_member = user.add_to_queue video

      expect(queue_member.video_title).to eq(video.title)
    end
  end

  describe '#rating' do
    context 'with a review present' do
      it "returns the associated user's review rating on the associated video" do
        user = Fabricate :user
        video = Fabricate :video, reviews: []
        review = Fabricate :review, user: user, video: video
        queue_member = user.add_to_queue video

        expect(queue_member.rating).to eq(review.rating)
      end
    end

    context 'with no review present' do
      it 'returns nil' do
        user = Fabricate :user
        video = Fabricate :video, reviews: []
        queue_member = user.add_to_queue video

        expect(queue_member.rating).to be_nil
      end
    end
  end

  describe '#category_name' do
    it "returns the name of the associated video's category" do
      user = Fabricate :user
      video = Fabricate :video
      queue_member = user.add_to_queue video

      expect(queue_member.category_name).to eq(video.category.name)
    end
  end

  describe '#rating=' do
    let!(:user) { Fabricate :user }
    let!(:video) { Fabricate :video, reviews: [] }
    let!(:queue_member) { user.add_to_queue video }

    context 'with no input' do
      context 'when a review exists' do
        let!(:review) { Fabricate :review, user: user, video: video }

        it "doesn't alter the review" do
          expect{ queue_member.rating = '' }.to_not change(queue_member.reload, :rating)
        end
      end

      context 'with no existing review' do
        it "doesn't create a new review" do
          expect{ queue_member.rating = '' }.to_not change{ video.reload.reviews.count }
        end
      end
    end

    context 'with same input as existing review' do
      let!(:review) { Fabricate :review, user: user, video: video, rating: 5}

      it "doesn't change the existing review" do
        queue_member.rating = 5
        expect(queue_member.rating).to eq(5)
      end
    end

    context 'with different input from existing review' do
      let!(:review) { Fabricate :review, user: user, video: video, rating: 5}

      it 'alters the review to match the input' do
        queue_member.rating = 4
        expect(queue_member.rating).to eq(4)
      end
    end

    context 'with input and no existing review' do
      before(:each) { queue_member.rating = 4 }

      it 'creates a new review' do
        expect(user.reviews.length).to be(1)
      end

      it "matches the new review's rating with the input" do
        expect(queue_member.rating).to eq(4)
      end

      it 'leaves the body of the new review blank' do
        expect(user.reviews.first.body).to be_blank
      end
    end
  end
end
