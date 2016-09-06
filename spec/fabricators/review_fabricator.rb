Fabricator :review do
  rating { rand(1..5) }
  body { Faker::Lorem.paragraph(rand(1..5)) }
  author
  video
end
