Fabricator :user do
  email { Faker::Internet.email }
  password { Faker::Internet.password }
  full_name { Faker::Name.name }
  active { true }
  admin { false }
end
