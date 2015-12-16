require 'test_helper'

class FavoriteRecipeTest < ActiveSupport::TestCase
  
  def setup
    @user = users(:michael)
    @recipe = recipes(:chocolate)
  end
  
  test "user should have favorite recipes" do 
    @user.favorites << @recipe
    assert @user.favorites.to_a.include?(@recipe)
  end 
  
  test "recipe should have favorited_by users" do 
    @recipe.favorited_by << @user
    assert @recipe.favorited_by.to_a.include?(@user)
  end
end
