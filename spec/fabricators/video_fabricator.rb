Fabricator :video do
  title { Faker::Lorem.words((1..5).to_a.sample).join(' ').titleize }
  description { Faker::Lorem.paragraph }
  remote_small_cover_url { Faker::Placeholdit.image '166x236' }
  remote_large_cover_url { Faker::Placeholdit.image '665x375' }
  watch_url 'https://www.youtube.com/watch?v=J5KkKdGDs5Y'
  reviews(rand: 15) { Fabricate(:review, video: nil) }
  category do
    if Category.any?
      Category.all.sample
    else
      Fabricate :category, name: %w(Comedy Drama Action Adventure Sci-Fi).sample
    end
  end
end
