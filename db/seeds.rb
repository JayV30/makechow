# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create!( name: "Jay Karlsven",
              email: "j.karlsven@gmail.com",
              password: "foobar",
              password_confirmation: "foobar",
              location: "Ohio",
              admin: true,
              activated: true,
              activated_at: Time.zone.now,
              image_url: "http://jpkarlsven.com/img/cartoon_jay.png")

99.times do |n|
  name = Faker::Name.name
  email = Faker::Internet.email
  password = "password"
  location = Faker::Address.city
  image_url = Faker::Avatar.image
  User.create!( name: name,
                email: email,
                password: password,
                password_confirmation: password,
                location: location,
                activated: true,
                activated_at: Time.zone.now,
                image_url: image_url)
end

User.first.recipes.create!( title: "Pumpkin Pie",
                            description: "Pumpkiny",
                            image_url: Faker::Avatar.image("pumpkinpie"),
                            prep_time: 10,
                            cook_time: 30,
                            steps: ["Fill pie pan with filling", "Place in oven for 30 minutes", "Enjoy!"])

users = User.where.not(id: 1)

10.times do |n|
  title = Faker::Lorem.word
  description = Faker::Lorem.sentence
  image_url = Faker::Avatar.image
  prep_time = n + 1
  cook_time = n + 2
  steps = [Faker::Lorem.sentence, Faker::Lorem.sentence, Faker::Lorem.sentence]
  users.each { |user| user.recipes.create!( title: title, description: description, image_url: image_url, prep_time: prep_time, cook_time: cook_time, steps: steps)}
end
