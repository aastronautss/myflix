Fabricator :review do
  rating { (1..5).to_a.sample }
  body { Faker::Lorem.paragraphs((1..5).to_a.sample).join("\n\n") }
  user do
    if User.any?
      User.all.sample
    else
      Fabricate :user
    end
  end
  video
end
