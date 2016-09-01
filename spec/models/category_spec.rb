require 'spec_helper'

describe Category do
  context 'associations' do
    it { should have_many(:videos) }
  end

  context 'validations' do
    it { should validate_presence_of(:name) }
  end

  describe '#recent_videos' do
    context 'with no videos' do
      it 'returns an empty array' do
        @movies = Category.create name: 'Movies'
        expect(@movies.recent_videos).to eq([])
      end
    end

    context 'with less than six videos' do
      it 'returns an array with all videos' do
        @movies = Category.create name: 'Movies'
        @mad_max = Video.create title: 'Mad Max',
                                description: 'Video 1',
                                created_at: 1.day.ago,
                                category: @movies
        @blue_velvet = Video.create title: 'Blue Velvet',
                                    description: 'Video 2',
                                    created_at: 2.days.ago,
                                    category: @movies
        @mad_max_2 = Video.create title: 'Mad Max 2: The Road Warrior',
                                  description: 'Video 3',
                                  created_at: 1.day.ago,
                                  category: @movies

        result = @movies.recent_videos
        expected = [ @blue_velvet,
                     @mad_max,
                     @mad_max_2 ]

        expect(result).to eq(expected)
      end
    end

    context 'with more than six videos' do
      before(:each) do
        @movies = Category.create name: 'Movies'
        @mad_max = Video.create title: 'Mad Max',
                                description: 'Video 1',
                                created_at: 1.day.ago,
                                category: @movies
        @blue_velvet = Video.create title: 'Blue Velvet',
                                    description: 'Video 2',
                                    created_at: 2.days.ago,
                                    category: @movies
        @mad_max_2 = Video.create title: 'Mad Max 2: The Road Warrior',
                                  description: 'Video 3',
                                  created_at: 1.day.ago,
                                  category: @movies
        @blazing_saddles = Video.create title: 'Blazing Saddles',
                                        description: 'Video 4',
                                        created_at: 2.days.ago,
                                        category: @movies
        @dark_city = Video.create title: 'Dark City',
                                  description: 'Video 5',
                                  created_at: 3.days.ago,
                                  category: @movies
        @dark_knight = Video.create title: 'The Dark Knight',
                                    description: 'Video 6',
                                    created_at: 1.day.ago,
                                    category: @movies
        @labyrinth = Video.create title: 'Labyrinth',
                                  description: 'Video 7',
                                  created_at: 2.days.ago,
                                  category: @movies
      end

      it 'returns six videos by default' do
        expect(@movies.recent_videos.length).to eq(6)
      end

      it 'returns a custom amount of videos' do
        expect(@movies.recent_videos(5).length).to eq(5)
      end

      it 'returns videos in order' do
        result = @movies.recent_videos
        expected = [ @blazing_saddles,
                     @blue_velvet,
                     @dark_city,
                     @labyrinth,
                     @mad_max,
                     @mad_max_2 ]

        expect(result).to eq(expected)
      end
    end
  end
end
