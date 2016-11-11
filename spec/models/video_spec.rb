require 'spec_helper'

describe Video do
  context 'associations' do
    it { should belong_to(:category) }
    it { should have_many(:reviews).
                  dependent(:destroy).
                  order('created_at desc') }
    it { should have_many(:queue_members).dependent(:destroy) }
  end

  context 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:description) }
  end

  describe ".search", :elasticsearch do
    let(:refresh_index) do
      Video.import
      Video.__elasticsearch__.refresh_index!
    end

    context "with title" do
      it "returns no results when there's no match" do
        Fabricate(:video, title: "Futurama")
        refresh_index

        expect(Video.search("whatever").records.to_a).to eq []
      end

      it "returns an empty array when there's no search term" do
        futurama = Fabricate(:video)
        south_park = Fabricate(:video)
        refresh_index

        expect(Video.search("").records.to_a).to eq []
      end

      it "returns an array of 1 video for title case insensitve match" do
        futurama = Fabricate(:video, title: "Futurama")
        south_park = Fabricate(:video, title: "South Park")
        refresh_index

        expect(Video.search("futurama").records.to_a).to eq [futurama]
      end

      it "returns an array of many videos for title match" do
        star_trek = Fabricate(:video, title: "Star Trek")
        star_wars = Fabricate(:video, title: "Star Wars")
        refresh_index

        expect(Video.search("star").records.to_a).to match_array [star_trek, star_wars]
      end
    end

    context "with title and description" do
      it "returns an array of many videos based for title and description match" do
        star_wars = Fabricate(:video, title: "Star Wars")
        about_sun = Fabricate(:video, description: "sun is a star")
        refresh_index

        expect(Video.search("star").records.to_a).to match_array [star_wars, about_sun]
      end
    end

    context "multiple words must match" do
      it "returns an array of videos where 2 words match title" do
        star_wars_1 = Fabricate(:video, title: "Star Wars: Episode 1")
        star_wars_2 = Fabricate(:video, title: "Star Wars: Episode 2")
        bride_wars = Fabricate(:video, title: "Bride Wars")
        star_trek = Fabricate(:video, title: "Star Trek")
        refresh_index

        expect(Video.search("Star Wars").records.to_a).to match_array [star_wars_1, star_wars_2]
      end
    end

    context "with title, description and reviews" do
      it 'returns an an empty array for no match with reviews option' do
        star_wars = Fabricate(:video, title: "Star Wars")
        batman    = Fabricate(:video, title: "Batman")
        batman_review = Fabricate(:review, video: batman, body: "such a star movie!")
        refresh_index

        expect(Video.search("no_match", reviews: true).records.to_a).to eq([])
      end

      it 'returns an array of many videos with relevance title > description > review' do
        star_wars = Fabricate(:video, title: "Star Wars")
        about_sun = Fabricate(:video, description: "the sun is a star!")
        batman    = Fabricate(:video, title: "Batman")
        batman_review = Fabricate(:review, video: batman, body: "such a star movie!")
        refresh_index

        expect(Video.search("star", reviews: true).records.to_a).to eq([star_wars, about_sun, batman])
      end
    end
  end

  describe '.search_by_title' do
    before(:each) do
      @mad_max = Video.create title: 'Mad Max',
                              description: 'Video 1',
                              created_at: 1.day.ago
      @blue_velvet = Video.create title: 'Blue Velvet', description: 'Video 2'
      @mad_max_2 = Video.create title: 'Mad Max 2: The Road Warrior',
                                description: 'Video 3'
    end

    context 'with an empty search string' do
      it 'returns an empty array' do
        expect(Video.search_by_title('')).to eq([])
      end
    end

    context 'with no results' do
      it 'returns an empty string' do
        expect(Video.search_by_title('Finding Nemo')).to eq([])
      end
    end

    context 'with one result' do
      it 'matches exact match' do
        result = Video.search_by_title('Blue Velvet')

        expect(result).to contain_exactly(@blue_velvet)
      end

      it 'is case insensitive' do
        result = Video.search_by_title('blue velvet')

        expect(result).to contain_exactly(@blue_velvet)
      end

      it 'matches partial match' do
        result = Video.search_by_title('blue')

        expect(result).to contain_exactly(@blue_velvet)
      end
    end

    context 'with multiple results' do
      it 'matches exact match ordered by created_at' do
        result = Video.search_by_title('Mad Max')

        expect(result).to eq([@mad_max, @mad_max_2])
      end

      it 'is case insensitive ordered by created_at' do
        result = Video.search_by_title('mad max')

        expect(result).to eq([@mad_max, @mad_max_2])
      end
    end
  end

  describe '#rating' do
    context 'with one review' do
      let(:video) { Fabricate :video, reviews: [] }
      before { video.reviews << Fabricate(:review, rating: 3, video: video) }

      it 'returns the rating for the review' do
        expect(video.rating).to eq(3.0)
      end
    end

    context 'with multiple reviews' do
      let(:video) { Fabricate :video, reviews: [] }
      before do
        video.reviews << Fabricate(:review, rating: 1, video: video)
        video.reviews << Fabricate(:review, rating: 5, video: video)
      end

      it 'returns the average of all the reviews' do
        expect(video.rating).to eq(3.0)
      end
    end

    context 'with no reviews' do
      let(:video) { Fabricate :video, reviews: [] }

      it 'returns nil' do
        expect(video.rating).to be_nil
      end
    end
  end
end
