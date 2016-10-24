require 'spec_helper'

describe Admin::VideosController do
  describe 'GET new' do
    let(:user) { Fabricate :user, admin: true }
    let(:action) { get :new }
    before { set_user user }

    it_behaves_like 'a private action'
    it_behaves_like 'an admin action'

    it 'sets @video to a new instance' do
      action
      expect(assigns(:video)).to be_instance_of(Video)
      expect(assigns(:video)).to be_new_record
    end

    it 'sets @categories' do
      action
      expect(assigns(:categories)).to respond_to(:each)
    end
  end

  describe 'POST create' do
    let(:user) { Fabricate :user, admin: true }
    let(:action) { post :create, video: Fabricate.attributes_for(:video, reviews: nil) }
    before { set_user user }

    it_behaves_like 'a private action'
    it_behaves_like 'an admin action'

    context 'with valid input' do
      it 'creates a video' do
        expect{ action }.to change(Video, :count).by(1)
      end

      it 'redirects to the video show page' do
        action
        expect(response).to redirect_to(Video.last)
      end
    end

    context 'with invalid input' do
      let(:action) { post :create, video: Fabricate.attributes_for(:video, reviews: nil, title: '') }

      it 'does not create a video' do
        expect{ action }.to change(Video, :count).by(0)
      end

      it 'sets @video' do
        action
        expect(assigns(:video)).to be_instance_of(Video)
      end

      it 'renders :new' do
        action
        expect(response).to render_template(:new)
      end
    end
  end
end
