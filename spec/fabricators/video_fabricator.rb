Fabricator :video do
  title { Faker::Book.title }
  description { Faker::Lorem.paragraph }
  small_cover_url { Faker::Placeholdit.image '166x236' }
  large_cover_url { Faker::Placeholdit.image '665x375' }
end
