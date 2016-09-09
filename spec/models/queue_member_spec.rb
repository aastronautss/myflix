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
end
