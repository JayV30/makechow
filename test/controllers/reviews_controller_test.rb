require 'test_helper'

class ReviewsControllerTest < ActionController::TestCase
  
  def setup
    @recipe = recipes(:chocolate)
    @review = reviews(:review_one)
    @user = users(:michael)
    @other_user = users(:archer)
  end
  
  test "should get index" do 
    get :index, recipe_id: @recipe.id
    assert_response :success
  end 
  
  test "should get show" do
    get :show, recipe_id: @recipe.id, id: @review.id
    assert_response :success
  end 
  
  test "should redirect create if not logged in" do 
    assert_no_difference 'Review.count' do
      post :create, review: {rating: 5, content: "Great", recipe_id: @recipe.id}
    end 
    assert_not flash.empty?
    assert_redirected_to login_url
  end 
  
  test "should redirect update if not logged in" do 
    patch :update, id: @review.id, review: {rating: 1, content: "Don't like it anymore"}
    assert_not flash.empty?
    assert_redirected_to login_url
  end 
  
  test "should redirect destroy if not logged in" do 
    assert_no_difference 'Review.count' do
      delete :destroy, id: @review.id
    end
    assert_redirected_to login_url
  end 
  
  test "should redirect update if current user is not the review owner (cannot modify another user's reviews)" do 
    log_in_as(@other_user)
    orig_review = @review
    patch :update, id: @review.id, recipe: { content: "new content" }
    assert orig_review.content == @review.content
    assert_not flash.empty?
    assert_redirected_to root_url
  end 
  
  test "should redirect destroy if current user is not the review owner (cannot destroy another user's reviews)" do 
    log_in_as(@other_user)
    assert_no_difference 'Review.count' do
      delete :destroy, id: @review.id
    end
    assert_not flash.empty?
    assert_redirected_to root_url
  end 
  
  
end
