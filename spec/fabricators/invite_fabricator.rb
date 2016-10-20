Fabricator :invite do
  name { Faker::Name.name }
  email { Faker::Internet.email }
  message { Faker::Lorem.words(rand(3..15)).join ' ' }
end
