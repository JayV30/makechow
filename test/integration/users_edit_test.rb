require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  include RecipesHelper 
 
  def setup
    @user = users(:michael)
  end
  
  test "unsuccessful edit" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), user: { name:   "",
                                    email:  "foo@invalid",
                                    password:   "foo",
                                    password_confirmation: "bar",
                                    location: "the moon" }
    assert_template 'users/edit'
  end
  
  test "succesful edit with friendly forwarding" do
    get edit_user_path(@user)
    log_in_as(@user)
    assert_redirected_to edit_user_path(@user)
    name = "Foo Bar"
    email = "foo@bar.com"
    location = "France"
    patch user_path(@user), user: { name: name,
                                    email: email,
                                    location: location,
                                    password: "",
                                    password_confirmation: "" }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name, @user.name
    assert_equal email, @user.email
    assert_equal location, @user.location
  end
  
end
