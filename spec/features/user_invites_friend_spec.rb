require 'spec_helper'

# feature 'user invites friend' do
#   scenario 'User successfully invites a friend and invitation is accepted' do
#     alice = Fabricate :user
#     sign_in alice

#     visit invite_path
#     fill_in 'Friend\'s Name', with: 'John Doe'
#     fill_in 'Friend\'s Email Address', with: 'john@doe.com'
#     fill_in 'Invitation Message', with: 'asdf'
#     click_button 'Send Invitation'

#     sign_out

#     open_email 'john@doe.com'
#     current_email.click_link 'Accept invitation'

#     fill_in 'Password', with: 'password'
#     click_button 'Sign Up'

#     fill_in 'Email Address', with: 'john@doe.com'
#     fill_in 'Password', with: 'password'
#     click_button 'Sign in'

#     click_link 'People'
#     expect(page).to have_content(alice.full_name)
#     sign_out

#     sign_in(alice)
#     click_link 'People'
#     expect(page).to have_content('John Doe')

#     clear_email
#   end
# end
