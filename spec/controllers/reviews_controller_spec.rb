require 'spec_helper'

describe ReviewsController do
  describe 'POST create' do
    context 'when logged out' do
      let(:video) { Fabricate :video }

      it 'redirects to root' do
        params = { review: Fabricate.attributes_for(:review, user: nil), video_id: video.id }
        post :create, params
        expect(response).to redirect_to(root_path)
      end
    end

    context 'when logged in' do
      let(:user) { Fabricate :user }
      let(:video) { Fabricate :video }
      before(:each) do
        session[:user_id] = user.id
        @action = -> (attrs) { post :create, attrs }
      end

      context 'with valid input' do
        let(:params) { { review: Fabricate.attributes_for(:review, user: nil),
                         video_id: video.id } }

        it 'creates a review' do
          expect{ @action.call params }.to change{ video.reviews.count }.by(1)
        end

        it 'creates a review associated with the video' do
          @action.call params
          expect(Review.last.video).to eq(video)
        end

        it 'creates a review associated with the signed-in user' do
          @action.call params
          expect(Review.last.user).to eq(user)
        end

        it 'redirects to the video show page' do
          @action.call params
          expect(response).to redirect_to(video)
        end
      end

      context 'with invalid input' do
        let(:params) { { review: Fabricate.attributes_for(:review,
                                                          user: nil,
                                                          rating: nil),
          video_id: video.id } }

        it 'does not create a review' do
          expect{ @action.call params }.to change{ video.reviews.count }.by(0)
        end

        it 'renders the videos/show template' do
          @action.call params
          expect(response).to render_template('videos/show')
        end

        it 'sets @video' do
          @action.call params
          expect(assigns(:video)).to eq(video)
        end

        it 'sets @reviews' do
          @action.call params
          expect(assigns(:reviews)).to match_array(video.reviews)
        end
      end
    end
  end
end
