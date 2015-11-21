require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  
  def setup
    @non_activated_user = users(:nonactive)
  end
  
  test "should get new" do
    get :new
    assert_response :success
  end
  
  test "should redirect create(login) when not activated" do
    post :create, session: { email: @non_activated_user.email, password: 'password' }
    assert_not flash.empty?
    assert_redirected_to root_url
    assert_not is_logged_in?
  end
  
end
