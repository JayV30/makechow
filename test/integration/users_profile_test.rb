require 'test_helper'

class UsersProfileTest < ActionDispatch::IntegrationTest
  include ApplicationHelper
  include RecipesHelper
  
  def setup
    @user = users(:michael)
    @other_user = users(:archer)
    @hidden_recipe = recipes(:hidden_recipe)
  end
  
  test "Profile Display" do
    log_in_as(@user)
    get user_path(@user)
    assert_template 'users/show'
    assert_select 'title', text: "#{@user.name} User Profile | Make Chow | Top food, snack, and drink recipes on the web"
    assert_select 'h1', text: @user.name
    assert_select 'ul.pagination'
    
    # ensure display of recipes
    @user.recipes.order(created_at: :desc).paginate(page: 1, per_page: 8).each do |recipe|
      assert_match recipe.title, response.body
      assert_match recipe.description[0...100], response.body
    end
    
    # ensure display of a hidden recipe
    assert_match @hidden_recipe.title, response.body
    
    # ensure display of reviews
    @user.reviews.order(created_at: :desc).paginate(page: 1, per_page: 6).each do |review|
      assert_match review.content, response.body
      assert_match review.recipe.title, response.body
    end
    
    # ensure display of favorites
    @user.favorites.order(created_at: :desc).paginate(page: 1, per_page: 8).each do |favorite|
      assert_match favorite.title, response.body
      assert_match favorite.description[0...100], response.body
    end
    
    # ensure hidden recipes not displayed when no logged in user
    log_out(@user)
    assert_not is_logged_in?
    get user_path(@user)
    # first ensure recipes are displayed
    @user.recipes.not_private.order(created_at: :desc).paginate(page: 1, per_page: 8).each do |recipe|
      assert_match recipe.title, response.body
      assert_match recipe.description[0...100], response.body
    end
    # now ensure that hidden recipe is NOT displayed
    assert_no_match @hidden_recipe.title, response.body
    
    # ensure a logged in user cannot see hidden recipes of another user
    log_in_as(@other_user)
    get user_path(@user)
    # first ensure recipes are displayed
    @user.recipes.not_private.order(created_at: :desc).paginate(page: 1, per_page: 8).each do |recipe|
      assert_match recipe.title, response.body
      assert_match recipe.description[0...100], response.body
    end
    # now ensure that hidden recipe is NOT displayed
    assert_no_match @hidden_recipe.title, response.body    
    
  end
  
  test "Display of edit profile, create recipe, edit recipe, and delete recipe buttons" do
    # A user should be able to see these buttons on their own profile
    log_in_as @user
    assert_redirected_to @user
    follow_redirect!
    assert_select 'a', text: "Edit Profile"
    assert_select 'a', text: "Create a new recipe"
    assert_select 'a', text: "Edit"
    assert_select 'a', text: "Delete"
    # A user should not be able to see these buttons on another profile
    get user_path(@other_user)
    assert_select 'a', { text: "Edit Profile", count: 0 }
    assert_select 'a', { text: "Create a new recipe", count: 0 }
    assert_select 'a', { text: "Edit", count: 0 }
    assert_select 'a', { text: "Delete", count: 0 }
    # Buttons should not display when no logged in user
    log_out(@user)
    assert_not is_logged_in?
    get user_path(@user)
    assert_select 'a', { text: "Edit Profile", count: 0 }
    assert_select 'a', { text: "Create a new recipe", count: 0 }
    assert_select 'a', { text: "Edit", count: 0 }
    assert_select 'a', { text: "Delete", count: 0 }
    get user_path(@other_user)
    assert_select 'a', { text: "Edit Profile", count: 0 }
    assert_select 'a', { text: "Create a new recipe", count: 0 }
    assert_select 'a', { text: "Edit", count: 0 }
    assert_select 'a', { text: "Delete", count: 0 }
  end
end
