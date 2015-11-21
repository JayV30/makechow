require 'test_helper'

class RecipeTest < ActiveSupport::TestCase
  
  def setup
    @user = users(:michael)
    @recipe = @user.recipes.build( title: "Chocolate Cake", description: "Delicious and Mouth Watering", prep_time: 10, cook_time: 10, servings: "2 servings")
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
  
  test "order should be most recent first" do 
    assert_equal recipes(:most_recent), Recipe.first
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
  
end
