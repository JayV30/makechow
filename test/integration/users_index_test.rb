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
  
end
