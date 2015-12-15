require 'test_helper'

class UsersProfileTest < ActionDispatch::IntegrationTest
  include ApplicationHelper
  include RecipesHelper
  
  def setup
    @user = users(:michael)
    @other_user = users(:archer)
  end
  
  test "Profile Display" do
    log_in_as(@user)
    get user_path(@user)
    assert_template 'users/show'
    assert_select 'title', text: "#{@user.name} User Profile | Make Chow | Top food, snack, and drink recipes on the web"
    assert_select 'h1', text: @user.name
  # use once fixtures have a test image  assert_select 'img.img-rounded', { :count => 1}
    assert_select 'ul.pagination'
    @user.recipes.order(created_at: :desc).paginate(page: 1, per_page: 8).each do |recipe|
      assert_match recipe.title, response.body
      assert_match recipe.description[0...100], response.body
    end
  end
  
  test "Display of edit profile, create recipe, edit recipe, and delete recipe buttons" do
    log_in_as @user # A user should be able to see these buttons on their own profile
    assert_redirected_to @user
    follow_redirect!
    assert_select 'a', text: "Edit Profile"
    assert_select 'a', text: "Create a new recipe"
    assert_select 'a', text: "Edit"
    assert_select 'a', text: "Delete"
    get user_path(@other_user) # A user should not be able to see these buttons on another profile
    assert_select 'a', { text: "Edit Profile", count: 0 }
    assert_select 'a', { text: "Create a new recipe", count: 0 }
    assert_select 'a', { text: "Edit", count: 0 }
    assert_select 'a', { text: "Delete", count: 0 }
  end
end
