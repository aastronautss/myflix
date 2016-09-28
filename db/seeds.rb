# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

tyler = User.create email: 'tyler@example.com', password: 'tyler', full_name: 'Tyler Guillen'

100.times { Fabricate :user }

User.all.each do |user|
  rand(0..10).times do
    user.follow User.all.sample
  end
end

%w(Comedy Drama Action Adventure Sci-Fi Horror Thriller).each do |cat|
  Category.create name: cat
end

500.times do
  Fabricate :video
end

User.all.each do |user|
  rand(0..20).times do
    user.add_to_queue Video.all.sample
  end
end
