require 'spec_helper'

describe VideosController do
  describe 'GET show' do
    let(:video) { Fabricate :video }

    context 'when logged in' do
      before(:each) do
        set_user
        get :show, id: video.id
      end

      it 'sets @video' do
        expect(assigns(:video)).to eq(video)
      end

      it 'sets @reviews' do
        expect(assigns(:reviews)).to match_array(video.reviews)
      end

      it 'renders the show template' do
        expect(response).to render_template(:show)
      end
    end

    it_behaves_like 'a private action' do
      let(:action) { get :show, id: video.id }
    end
  end

  describe 'GET search' do
    let(:video) { Fabricate :video }

    context 'when logged in' do
      before(:each) do
        set_user
        get :search, q: video.title.downcase
      end

      it 'sets @results' do
        expect(assigns(:results)).to exist
      end

      it 'renders the search template' do
        expect(response).to render_template(:search)
      end
    end

    it_behaves_like 'a private action' do
      let(:action) { get :search, q: video.title.downcase }
    end
  end
end
