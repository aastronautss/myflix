shared_examples 'a private action' do
  before { clear_current_user }

  context 'when not logged in' do
    it 'redirects to root path' do
      action
      expect(response).to redirect_to(root_path)
    end
  end
end
