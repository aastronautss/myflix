require 'spec_helper'

describe Admin::PaymentsController do
  describe 'GET index' do
    let(:user) { Fabricate :user, admin: true }
    let(:action) { get :index }
    before { set_user user }

    it_behaves_like 'a private action'
    it_behaves_like 'an admin action'
  end
end
