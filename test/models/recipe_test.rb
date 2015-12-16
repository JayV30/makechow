require 'test_helper'

class RecipeTest < ActiveSupport::TestCase
  
  def setup
    @user = users(:michael)
    @recipe = @user.recipes.build( title: "Chocolate Cake", description: "Delicious and Mouth Watering", prep_time: 10, cook_time: 10, servings: "2 servings", hidden: false, category: "Breakfast", cuisine: "American", course: "Dessert")
    @image_recipe = recipes(:most_recent)
    @no_image_recipe = recipes(:cherry)
  end
  
  test "recipe should be valid" do
    assert @recipe.valid?
  end
  
  test "user_id should be present" do 
    @recipe.user_id = nil
    assert_not @recipe.valid?
  end
  
  test "title should be present" do 
    @recipe.title = nil
    assert_not @recipe.valid?
  end
  
  test "description should be present" do
    @recipe.description = nil
    assert_not @recipe.valid?
  end
  
  test "prep time should be present and greater than -1" do 
    @recipe.prep_time = nil
    assert_not @recipe.valid?
    @recipe.prep_time = -2
    assert_not @recipe.valid?
    @recipe.prep_time = 0
    assert @recipe.valid?
  end
  
  test "cook time should be present and greater than -1" do 
    @recipe.cook_time = nil
    assert_not @recipe.valid?
    @recipe.cook_time = -1
    assert_not @recipe.valid?
    @recipe.cook_time = 1
    assert @recipe.valid?
  end
  
  test "servings should be present" do 
    @recipe.servings = nil
    assert_not @recipe.valid?
  end
  
  test "hidden should be a boolean" do
    @recipe.hidden = true
    assert @recipe.valid?
    @recipe.hidden = false
    assert @recipe.valid?
    @recipe.hidden = nil
    assert_not @recipe.valid?
  end
  
  test "should be able to have an image_url" do 
    assert File.exists?(@image_recipe.image_url.file.path)
    assert @image_recipe.valid?
  end
  
  test "should be able to upload a valid image_url" do
    @no_image_recipe.image_url = fixture_file_upload('/files/right_size.jpg', 'image/jpg')
    assert(File.exists?(@no_image_recipe.reload.image_url.file.path))
  end
  
  test "should not be able to upload a image over 5 megabytes" do
    @no_image_recipe.image_url = fixture_file_upload('/files/too_large.jpg', 'image/jpg')
    assert_not @no_image_recipe.valid?
  end
  
  test "category should be present and only one of the values in Recipe::CUISINE_OPTIONS" do
    @recipe.category = nil
    assert_not @recipe.valid?
    @recipe.category = "Breakfast"
    assert @recipe.valid?
    @recipe.category = "Smorgasboard"
    assert_not @recipe.valid?
  end
  
  test "cuisine should be present and only one of the values in Recipe::CUISINE_OPTIONS" do
    @recipe.cuisine = nil
    assert_not @recipe.valid?
    @recipe.cuisine = "Italian"
    assert @recipe.valid?
    @recipe.cuisine = "Martian"
    assert_not @recipe.valid?
  end
  
  test "course should be present and only one of the values in Recipe::COURSE_OPTIONS" do 
    @recipe.course = nil
    assert_not @recipe.valid?
    @recipe.course = "Appetizer"
    assert @recipe.valid?
    @recipe.course = "Gorging"
    assert_not @recipe.valid?
  end
  
  test "average_rating should be present and only a float from 0-5" do 
    @recipe.average_rating = -1.2
    assert_not @recipe.valid?
    @recipe.average_rating = 5.1
    assert_not @recipe.valid?
    # ensure inclusive
    @recipe.average_rating = 0
    assert @recipe.valid?
    @recipe.average_rating = 5
    assert @recipe.valid?
  end
  
  test "total_time should be set before save" do 
    @recipe = @user.recipes.build(title: "Hamburgers", description: "Hot off the grill", prep_time: 20, cook_time: 20, servings: "1 burger", hidden: false, category: "Dinner", cuisine: "American", course: "Main dish")
    assert @recipe.total_time.nil?
    @recipe.save
    assert_equal 40, @recipe.total_time
  end
  
  test "scope sort_by('Date') should list most recent first" do
    assert_equal recipes(:most_recent), Recipe.sort_by("Date").first
    assert_equal recipes(:chocolate), Recipe.sort_by("Date").last
  end
  
  test "scope sort_by('Rating') should list highest rated first" do 
    assert_equal recipes(:highest_rated), Recipe.sort_by("Rating").first
    assert_equal recipes(:chocolate), Recipe.sort_by("Rating").last
  end 
  
  test "scope sort_by('Time to Make') should list shortest total time recipes first" do 
    assert_equal recipes(:shortest_time), Recipe.sort_by("Time to Make").first
    assert_equal recipes(:hidden_recipe), Recipe.sort_by("Time to Make").last
  end
  
  test "scope not_private should not return private recipes" do
    actual = Recipe.not_private.to_a
    assert_not actual.include?(recipes(:hidden_recipe))
  end
  
  test "scope category should return only recipes in the provided category" do 
    actual = Recipe.category("Brunch").to_a
    assert_equal 1, actual.size
    assert_not actual.include?(recipes(:chocolate))
    assert actual.include?(recipes(:cherry))
  end
  
  test "scope cuisine should return only recipes in the provided cuisine type" do
    actual = Recipe.cuisine("Greek").to_a
    assert_equal 1, actual.size
    assert_not actual.include?(recipes(:highest_rated))
    assert actual.include?(recipes(:shortest_time))
  end 
  
  test "scope course should return only recipes in the provided course" do 
    actual = Recipe.course("Finger food").to_a
    assert_equal 1, actual.size
    assert_not actual.include?(recipes(:cherry))
    assert actual.include?(recipes(:most_recent))
  end 
  
  test "scope popular should only return recipes with an average_rating of 3.5 or greater" do 
    actual = Recipe.popular.to_a
    assert_equal 1, actual.size
    assert_not actual.include?(recipes(:shortest_time))
    assert actual.include?(recipes(:highest_rated))
  end
  
  test "scope latest should only return recipes with a creation date of less than 5 days ago" do 
    actual = Recipe.latest.to_a
    assert_not actual.include?(recipes(:chocolate))
  end
  
  test "scope quick should only return recipes where the total_time is 30 minutes or less" do 
    actual = Recipe.quick.to_a
    assert_equal 1, actual.size
    assert_not actual.include?(recipes(:cherry))
    assert actual.include?(recipes(:shortest_time))
  end
  
  test "associated steps should be destroyed" do
    @recipe.save
    @recipe.steps.create!(step_number: 1, content: "Lorem ipsum")
    assert_difference 'Step.count', -1 do 
      @recipe.destroy
    end
  end
  
  test "associated ingredients should be destroyed" do
    @recipe.save
    @recipe.ingredients.create!(name: "Lorem ipsum", quantity: "8 cups")
    assert_difference 'Ingredient.count', -1 do
      @recipe.destroy
    end
  end
  
  test "associated reviews should be destroyed" do
    @recipe.save
    @recipe.reviews.create!(rating: 5, content: "great!", user_id: @user.id)
    assert_difference 'Review.count', -1 do
      @recipe.destroy
    end
  end
  
  test "should be able to be favorited by a user" do
    @user.save
    assert_difference 'FavoriteRecipe.count', 1 do
      @user.favorites << @recipe
    end
  end
  
  test "associated join table rows in favorite_recipes should be destroyed" do 
    @user.save
    @recipe.save
    @user.favorites << @recipe
    assert_difference 'FavoriteRecipe.count', -1 do 
      @recipe.destroy
    end
  end
end
