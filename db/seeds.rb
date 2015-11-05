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