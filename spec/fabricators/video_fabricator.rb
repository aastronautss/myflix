Fabricator :video do
  title { Faker::Lorem.words((1..5).to_a.sample).join(' ').titleize }
  description { Faker::Lorem.paragraph }
  small_cover_url { Faker::Placeholdit.image '166x236' }
  large_cover_url { Faker::Placeholdit.image '665x375' }
  reviews(rand: 15) { Fabricate(:review, video: nil) }
  category do
    if Category.any?
      Category.all.sample
    else
      Fabricate :category, name: %w(Comedy Drama Action Adventure Sci-Fi).sample
    end
  end
end
