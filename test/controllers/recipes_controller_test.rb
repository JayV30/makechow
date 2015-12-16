require 'test_helper'

class RecipesControllerTest < ActionController::TestCase
  
  def setup
    @recipe = recipes(:chocolate)
    @hidden_recipe = recipes(:hidden_recipe)
    @user = users(:michael)
    @other_user = users(:archer)
    @collection = collections(:two)
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
                              total_time: 90,
                              category: "Lunch",
                              cuisine: "American",
                              course: "Dessert",
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
  
  test "should redirect favorite when not logged in" do
    assert_no_difference '@recipe.favorited_by.size' do
      put :favorite, id: @recipe.id
    end 
    assert_not flash.empty?
    assert_redirected_to login_url
  end
  
  test "should redirect admin view when not logged in" do 
    get :admin_view
    assert_not flash.empty?
    assert_redirected_to login_url
  end
  
  test "should redirect add_to_collection when not logged in" do 
    assert_no_difference '@recipe.collections.size' do
      put :add_to_collection, id: @recipe.id
    end 
    assert_not flash.empty?
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
  
  test "should not allow show of hidden(private) recipe unless current user is the owner of the recipe" do 
    get :show, id: @hidden_recipe.id
    assert_not flash.empty?
    assert_redirected_to root_url
  end 
  
  test "should show hidden recipe to recipe owner" do 
    log_in_as(@user)
    get :show, id: @hidden_recipe.id
    assert flash.empty?
    assert_response :success
  end
    
  test "should redirect admin_view when not admin user" do 
    log_in_as(@other_user)
    get :admin_view
    assert_not flash.empty?
    assert_redirected_to root_url
  end 
  
  test "should not allow add_to_collection unless admin user" do 
    log_in_as(@other_user)
    assert_no_difference '@recipe.collections.size' do
      put :add_to_collection, id: @recipe.id, collection: @collection.id
    end
    assert_not flash.empty?
    assert_redirected_to root_url
  end
end
