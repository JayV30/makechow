require 'test_helper'

class RecipesControllerTest < ActionController::TestCase
  
  def setup
    @recipe = recipes(:chocolate)
    @user = users(:michael)
    @other_user = users(:archer)
  end
  
  test "should redirect new when not logged in" do 
    get :new
    assert_redirected_to login_url
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
    get :edit, id: @recipe.id
    assert_not flash.empty?
    assert_redirected_to login_url
  end
  
  test "should redirect update when not logged in" do 
    patch :update, id: @recipe.id, recipe: { title: "New Title", prep_time: 120 }
    assert_not flash.empty?
    assert_redirected_to login_url
  end
  
  test "should redirect destroy when not logged in" do 
    assert_no_difference 'Recipe.count' do
      delete :destroy, id: @recipe.id
    end
    assert_redirected_to login_url
  end
  
  test "should not allow edit of another users recipe" do
    log_in_as(@other_user)
    get :edit, id: @recipe.id
    assert_not flash.empty?
    assert_redirected_to root_url
  end
  
  test "should not allow update of another users recipe" do
    log_in_as(@other_user)
    orig_recipe = @recipe
    patch :update, id: @recipe.id, recipe: { description: "new content" }
    assert orig_recipe.description == @recipe.description
    assert_not flash.empty?
    assert_redirected_to root_url
  end
  
  test "should not allow destroy of another users recipe" do
    log_in_as(@other_user)
    assert_no_difference 'Recipe.count' do
      delete :destroy, id: @recipe.id
    end
    assert_not flash.empty?
    assert_redirected_to root_url
  end
    
end
