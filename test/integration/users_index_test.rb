require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest
  include RecipesHelper
  
  def setup
    @admin = users(:michael)
    @non_admin = users(:morty)
  end
  
  test "index including pagination and delete links for admin user" do
    log_in_as(@admin)
    get users_path
    assert_template 'users/index'
    assert_select 'ul.pagination'
    first_page_of_users = User.paginate(page: 1)
    first_page_of_users.each do |user|
      assert_select 'a[href=?]', user_path(user), text: "View Profile"
      assert_select 'a[href=?]', user_path(user), text: "Delete User"
    end
    assert_difference 'User.count', -1 do
      delete user_path(@non_admin)
    end
  end
  
  test "not admin user redirected to root" do 
    log_in_as @non_admin
    get users_path
    assert_redirected_to root_url
    follow_redirect!
    assert_template 'collections/index'
  end
  
  test "non logged in user redirected to login" do 
    get users_path
    assert_redirected_to login_url
    follow_redirect!
    assert_template 'sessions/new'
  end
  
end
