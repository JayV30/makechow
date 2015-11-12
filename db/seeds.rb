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
              remote_image_url_url: "http://jpkarlsven.com/img/cartoon_jay.png")
              
User.create!( name: "Non Admin",
              email: "jay@jpkarlsven.com",
              password: "foobar",
              password_confirmation: "foobar",
              location: "Columbus, Ohio",
              admin: false,
              activated: true,
              activated_at: Time.zone.now,
              remote_image_url_url: "http://jpkarlsven.com/img/cartoon_jay.png")

99.times do |n|
  name = Faker::Name.name
  email = Faker::Internet.email
  password = "password"
  location = Faker::Address.city
  image_url = Faker::Lorem.word
  User.create!( name: name,
                email: email,
                password: password,
                password_confirmation: password,
                location: location,
                activated: true,
                activated_at: Time.zone.now,
                remote_image_url_url: "https://robohash.org/#{image_url}.png")
end

User.first.recipes.create!( title: "Pumpkin Pie",
                            description: "Pumpkiny",
                            remote_image_url_url: "https://robohash.org/pumpkinpie.png",
                            prep_time: 10,
                            cook_time: 30,
                            servings: "1 pie - 8 servings")
                            
User.first.recipes.create!( title: "Chocolate Cake",
                            description: "Moist, delcious chocolate cake that is SUPER EASY to make!",
                            remote_image_url_url: "https://robohash.org/chocolatecake.png",
                            prep_time: 50,
                            cook_time: 50,
                            servings: "1 cake - 12 slices")

users = User.where.not(id: 1)

10.times do |n|
  users.each { |user| 
    title = Faker::Lorem.word
    description = Faker::Lorem.sentence
    image_url = Faker::Lorem.word
    prep_time = n + 1
    cook_time = n + 2
    servings = rand(1...20).to_s + " " + Faker::Lorem.word
  
    user.recipes.create!( title: title, description: description, remote_image_url_url: "https://robohash.org/#{image_url}.png", prep_time: prep_time, cook_time: cook_time, servings: servings )
  }
end
