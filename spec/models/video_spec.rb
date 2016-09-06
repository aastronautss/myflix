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

  describe '#average_review' do
    let(:video) { Fabricate :video }

    context 'with no reviews' do

    end
  end
end
