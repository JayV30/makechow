require 'test_helper'

class IngredientTest < ActiveSupport::TestCase
  def setup
    @user = users(:michael)
    @recipe = @user.recipes.build( title: "Chocolate Cake", description: "Delicious and Mouth Watering", prep_time: 10, cook_time: 10, servings: "2 servings")
    @ingredient = @recipe.ingredients.build( quantity: "2 cups", name: "flour" )
  end
  
  test "ingredient should be valid" do
    assert @ingredient.valid?
  end
  
  test "recipe_id should be created" do
    assert_equal @recipe.id, @ingredient.recipe_id
  end
  
  test "quantity should be present" do 
    @ingredient.quantity = nil
    assert_not @ingredient.valid?
  end
  
  test "name should be present" do 
    @ingredient.name = nil
    assert_not @ingredient.valid?
  end
  
  test "name should be less than 130 characters" do 
    @ingredient.name = "z" * 131
    assert_not @ingredient.valid?
  end
  
  test "quantity should be less than 80 characters" do 
    @ingredient.quantity = "a" * 81
    assert_not @ingredient.valid?
  end
  
end
