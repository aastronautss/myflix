require 'spec_helper'

describe VideoDecorator do
  describe 'star_rating' do
    context 'when video has reviews' do
      let(:video) { Fabricate :video, reviews: [] }
      before do
        video.reviews << Fabricate(:review, video: video, rating: 1)
        video.reviews << Fabricate(:review, video: video, rating: 5)
      end

      it 'returns a decimal average over 5.0' do
        expect(video.decorate.star_rating).to eq('3.0 / 5.0')
      end
    end

    context 'when video has no reviews' do
      let(:video) { Fabricate :video, reviews: [] }

      it 'returns "N/A"' do
        expect(video.decorate.star_rating).to eq('N/A')
      end
    end
  end
end
