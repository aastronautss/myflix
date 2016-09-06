Fabricator :video do
  title { Faker::Lorem.words.join(' ').titleize }
  description { Faker::Lorem.paragraph }
  small_cover_url { Faker::Placeholdit.image '166x236' }
  large_cover_url { Faker::Placeholdit.image '665x375' }
  reviews(rand: 15)
end
