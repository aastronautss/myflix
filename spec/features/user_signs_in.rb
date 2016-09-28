require 'spec_helper'

feature 'user signs in' do
  let(:user) { Fabricate :user, password: 'password' }

  scenario 'with valid email and password' do
    sign_in(user)

    expect(page).to have_content(user.full_name)
  end

  scenario 'with invalid email and password' do
    visit login_path
    fill_in 'Email Address', with: user.email
    fill_in 'Password', with: 'wrongpassword'
    click_button 'Sign in'

    expect(page).to have_content("There's something wrong with your email or password.")
  end
end
