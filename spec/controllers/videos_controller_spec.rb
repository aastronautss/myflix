require 'spec_helper'

describe VideosController do
  describe 'GET show' do
    let(:video) { Fabricate :video }

    context 'when not logged in' do
      before(:each) do
        session[:user_id] = nil
        get :show, { id: video.id }
      end

      it 'redirects to root path' do
        expect(response).to redirect_to(root_path)
      end
    end

    context 'when logged in' do
      before(:each) do
        session[:user_id] = Fabricate(:user).id
        get :show, { id: video.id }
      end

      it 'sets the @video variable' do
        expect(assigns(:video)).to eq(video)
      end

      it 'renders the show template' do
        expect(response).to render_template(:show)
      end
    end
  end

  describe 'GET search' do
    let(:video) { Fabricate :video }

    context 'when not logged in' do
      before(:each) do
        session[:user_id] = nil
        get :search, { q: video.title.downcase }
      end


      it 'redirects to root path' do
        expect(response).to redirect_to(root_path)
      end
    end

    context 'when logged in' do
      before(:each) do
        session[:user_id] = Fabricate(:user).id
        get :search, q: video.title.downcase
      end

      it 'sets the @results variable' do
        expect(assigns(:results)).to exist
      end

      it 'renders the search template' do
        expect(response).to render_template(:search)
      end
    end
  end
end
