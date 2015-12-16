require 'test_helper'

class CollectionsControllerTest < ActionController::TestCase
  
  def setup
    @collection = collections(:one)
    @user = users(:michael)
    @other_user = users(:archer)
    @recipe = recipes(:chocolate)
  end 
  
  test "should get index" do 
    get :index
    assert_response :success
  end
  
  test "should get show" do 
    get :show, id: @collection.id
  end
  
  test "should redirect new if not logged in" do 
    get :new 
    assert_not flash.empty?
    assert_redirected_to login_url
  end 
  
  test "should redirect create if not logged in" do 
    assert_no_difference 'Collection.count' do
      post :create, collection: {name: "A collection", description: "Some things in a collection"}
    end 
    assert_not flash.empty?
    assert_redirected_to login_url
  end 
  
  test "should redirect update if not logged in" do 
    patch :update, id: @collection.id, collection: {name: "A changed collection", description: "updated things in a collection"}
    assert_not flash.empty?
    assert_redirected_to login_url
  end 
  
  test "should redirect destroy if not logged in" do 
    assert_no_difference 'Collection.count' do
      delete :destroy, id: @collection.id
    end
    assert_redirected_to login_url
  end
  
  test "should redirect admin_view if not logged in" do 
    get :admin_view
    assert_not flash.empty?
    assert_redirected_to login_url
  end 
  
  test "should redirect remove_from_collection if not logged in" do 
    assert_no_difference '@collection.recipes.count' do
      put :remove_from_collection, id: @collection.id
    end 
    assert_not flash.empty?
    assert_redirected_to login_url
  end 
  
  test "should redirect new if not admin user" do 
    log_in_as(@other_user)
    get :new 
    assert_not flash.empty?
    assert_redirected_to root_url
  end 
  
  test "should redirect create if not admin user" do 
    log_in_as(@other_user)
    assert_no_difference 'Collection.count' do
      post :create, collection: {name: "A collection", description: "Some things in a collection"}
    end 
    assert_not flash.empty?
    assert_redirected_to root_url
  end 
  
  test "should redirect edit if not admin user" do 
    log_in_as(@other_user)
    get :edit, id: @collection.id
    assert_not flash.empty?
    assert_redirected_to root_url
  end 
  
  test "should redirect update if not admin user" do 
    log_in_as(@other_user)
    patch :update, id: @collection.id, collection: {name: "A changed collection", description: "updated things in a collection"}
    assert_not flash.empty?
    assert_redirected_to root_url
  end 
  
  test "should redirect destroy if not admin user" do 
    log_in_as(@other_user)
    assert_no_difference 'Collection.count' do
      delete :destroy, id: @collection.id
    end
    assert_redirected_to root_url
  end 
  
  test "should redirect admin_view if not admin user" do 
    log_in_as(@other_user)
    get :admin_view
    assert_not flash.empty?
    assert_redirected_to root_url
  end 
  
  test "should redirect remove_from_collection if not admin user" do 
    log_in_as(@other_user)
    assert_no_difference '@collection.recipes.size' do
      put :remove_from_collection, id: @collection.id, recipe: @recipe.id
    end 
    assert_not flash.empty?
    assert_redirected_to root_url
  end 
end
