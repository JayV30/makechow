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

# Create 20 other Users                           
20.times do |n|
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


# Create 10 Recipies for each user
users = User.all

10.times do |n|
  users.each { |user| 
    title = Faker::Lorem.word + " " + Faker::Lorem.word
    description = Faker::Lorem.paragraph
    image_url = Faker::Lorem.word
    prep_time = rand(1...100)
    cook_time = rand(1...120)
    servings = rand(1...20).to_s + " " + Faker::Lorem.word
  
    user.recipes.create!( title: title, description: description, remote_image_url_url: "https://robohash.org/#{image_url}.png", prep_time: prep_time, cook_time: cook_time, servings: servings )
  }
end

# Create 5 Steps for each Recipe
recipes = Recipe.all

5.times do |n|
  recipes.each { |recipe|
    step_number = n
    content = Faker::Lorem.paragraph
    
    recipe.steps.create!( step_number: step_number, content: content)
  }
end

# Create 5 Ingredients for each Recipe
5.times do |n|
  recipes.each { |recipe|
    quantity = rand(1...30).to_s + " " + Faker::Lorem.word
    name = Faker::Lorem.word
    
    recipe.ingredients.create!(quantity: quantity, name: name)
  }
end

# Create 10 Reviews for each Recipe
10.times do |n|
  recipes.each { |recipe|
    user = User.order("RANDOM()").first
    recipe_id = recipe.id
    rating = rand(1...5)
    content = Faker::Lorem.sentence
    
    user.reviews.create!(recipe_id: recipe_id, rating: rating, content: content)
  }
end
  
