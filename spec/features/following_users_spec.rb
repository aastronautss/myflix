require 'spec_helper'

feature 'following users' do
  scenario 'user follows and unfollows someone' do
    category = Fabricate :category, name: 'Horror'
    video = Fabricate :video
    alice = Fabricate :user
    Fabricate :review, user: alice, video: video

    sign_in
    click_on_video_on_home_page video

    click_link alice.full_name
    click_link "Follow"
    expect(page).to have_content(alice.full_name)

    unfollow(alice)
    expect(page).to_not have_content(alice.full_name)
  end

  def unfollow(user)
    find("a[data-method='delete']").click
  end
end
