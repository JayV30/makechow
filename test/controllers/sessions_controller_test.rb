require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  include SessionsHelper
  
  def setup
    @activated_user = users(:michael)
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
  
  test "should not allow create(login) when invalid email or password" do
    # invalid email, valid password
    post :create, session: { email: "invalid@email.com", password: 'password' }
    assert_not flash.empty?
    assert_not is_logged_in?
    # valid email, invalid password
    post :create, session: { email: @activated_user.email, password: 'invalid' }
    assert_not flash.empty?
    assert_not is_logged_in?
  end
  
  test "should create a new session with valid login information" do
    post :create, session: { email: @activated_user.email, password: 'password'}
    assert is_logged_in?
  end
  
  test "should log out on destroy" do
    post :create, session: { email: @activated_user.email, password: 'password'}
    assert is_logged_in?
    post :destroy
    assert_not is_logged_in?
    assert_not flash.empty?
    assert_redirected_to root_url
  end
  
end
