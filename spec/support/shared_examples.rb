shared_examples 'a private action' do
  before { clear_current_user }

  context 'when not logged in' do
    it 'redirects to root path' do
      action
      expect(response).to redirect_to(root_path)
    end
  end
end

shared_examples 'an admin action' do
  context 'when logged in as a non-admin' do
    let(:user) { Fabricate :user, admin: false }
    before { set_user user }

    it 'sets the flash' do
      action
      expect(flash[:danger]).to be_present
    end

    it 'redirects to root' do
      action
      expect(response).to redirect_to(root_path)
    end
  end
end

shared_examples 'a tokenable model' do
  it 'generates a token on creation' do
    expect(model.token).to be_present
  end

  describe '#expire_token' do
    it 'removes the token' do
      model.expire_token
      expect(model.token).to be_nil
    end
  end
end
