require 'test_helper'

class RecipesControllerTest < ActionController::TestCase
  
  def setup
    @recipe = recipes(:chocolate)
  end
  
  test "should redirect create when not logged in" do 
    assert_no_difference 'Recipe.count' do 
      post :create, recipe: { title: "Lava Cake",
                              description: "perfect",
                              prep_time: 40,
                              cook_time: 50,
                              servings: "2 servings" }
    end
    assert_redirected_to login_url
  end
  
  test "should redirect edit when not logged in" do
    get :edit, id: @recipe
    assert_not flash.empty?
    assert_redirected_to login_url
  end
  
  test "should redirect update when not logged in" do 
    patch :update, id: @recipe, recipe: { title: "New Title", prep_time: 120 }
    assert_not flash.empty?
    assert_redirected_to login_url
  end
  
  test "should redirect destroy when not logged in" do 
    assert_no_difference 'Recipe.count' do
      delete :destroy, id: @recipe
    end
    assert_redirected_to login_url
  end
    
end
