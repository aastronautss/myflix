require 'spec_helper'

feature 'queue features' do
  let!(:categories) { Fabricate.times 2, :category, name: %w(Action Drama).sample }
  let!(:videos) { Fabricate.times 4, :video }

  scenario 'user interacts with the queue' do
    sign_in

    find("a[href='/videos/#{videos[0].id}']").click
    expect(page).to have_content(videos[0].title)

    click_link '+ My Queue'
    expect(page).to have_content(videos[0].title)

    click_link videos[0].title
    expect(page).to have_content(videos[0].title)
    expect(page).to_not have_content('+ My Queue')

    (1..2).each do |idx|
      visit videos_path
      find("a[href='/videos/#{videos[idx].id}']").click
      click_link '+ My Queue'
    end

    expect(page).to have_content(videos[1].title)
    expect(page).to have_content(videos[2].title)

    within(:xpath, "//tr[contains(.,'#{videos[0].title}')]") do
      fill_in 'queue_members[][position]', with: 2
    end

    within(:xpath, "//tr[contains(.,'#{videos[1].title}')]") do
      fill_in 'queue_members[][position]', with: 3
    end

    within(:xpath, "//tr[contains(.,'#{videos[2].title}')]") do
      fill_in 'queue_members[][position]', with: 1
    end

    click_button 'Update Instant Queue'

    expect(find(:xpath, "//tr[contains(.,'#{videos[0].title}')]//input[@type='text']").value).to eq('2')
    expect(find(:xpath, "//tr[contains(.,'#{videos[1].title}')]//input[@type='text']").value).to eq('3')
    expect(find(:xpath, "//tr[contains(.,'#{videos[2].title}')]//input[@type='text']").value).to eq('1')
  end
end
