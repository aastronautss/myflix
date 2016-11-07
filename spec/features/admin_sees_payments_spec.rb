require 'spec_helper'

feature 'admin sees payments' do
  background do
    user = Fabricate :user, full_name: 'Alice Doe', email: 'alice@example.com'
    Fabricate(:payment, amount: 999, user: user)
  end

  scenario 'admin can see payments' do
    sign_in(Fabricate :user, admin: true)
    visit admin_payments_path

    expect(page).to have_content('$9.99')
    expect(page).to have_content('Alice Doe')
    expect(page).to have_content('alice@example.com')
  end

  scenario 'user cannot see payments' do
    sign_in(Fabricate :user)
    visit admin_payments_path

    expect(page).to have_content('You do not have access to that area')
  end
end
