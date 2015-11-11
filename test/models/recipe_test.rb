require 'test_helper'

class RecipeTest < ActiveSupport::TestCase
  
  def setup
    @user = users(:michael)
    @recipe = @user.recipes.build( title: "Chocolate Cake", description: "Delicious and Mouth Watering", prep_time: 10, cook_time: 10, servings: "2 servings")
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
  
  test "order should be most recent first" do 
    assert_equal recipes(:most_recent), Recipe.first
  end
  
end
