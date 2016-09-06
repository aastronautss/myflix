# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

tyler = User.create email: 'tyler@example.com', password: 'tyler', full_name: 'Tyler Guillen'

25.times { Fabricate :user }

%w(Comedy Drama Action Adventure Sci-Fi Horror Thriller).each do |cat|
  Category.create name: cat
end

50.times do
  Fabricate :video
end
