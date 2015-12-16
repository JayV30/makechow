require 'test_helper'

class ReviewTest < ActiveSupport::TestCase
  
  def setup
    @review = reviews(:review_one)
    @two_review_recipe = recipes(:most_recent)
    @recipe = recipes(:highest_rated)
  end
  
  test "review should be valid" do
    assert @review.valid?
  end
  
  test "content may be blank" do
    @review.content = "  "
    assert @review.valid?
  end
  
  test "rating should be present" do
    @review.rating = nil
    assert_not @review.valid?
  end
  
  test "recipe_id should be present" do
    @review.recipe_id = nil
    assert_not @review.valid?
  end
  
  test "content should be less than 1000 characters" do
    @review.content = "x" * 1001
    assert_not @review.valid?
  end
  
  test "rating should be an integer from 1 to 5 (inclusive)" do
    assert_kind_of Integer, @review.rating
    @review.rating = 0
    assert_not @review.valid?
    @review.rating = 6
    assert_not @review.valid?
    @review.rating = 5
    assert @review.valid?
  end
  
  test "order should be most recent first" do
    assert_equal reviews(:review_three), Review.first
  end
  
  test "parent recipe of review should have a count of recipes" do
    assert_equal 2, @two_review_recipe.reviews.size
  end
  
  test "after save of review, average_rating of parent recipe should be updated" do
    # ensure the average_rating is saved in the database prior to building a new review
    @recipe.reviews << @review
    @recipe.save
    assert_equal 5, Recipe.find(@recipe.id).average_rating
    # build a review
    @bad_review = users(:archer).reviews.build(rating: 1, content: "A bad review", recipe_id: @recipe.id)
    @bad_review.save
    # after save, recipe.average_rating should be updated
    # average of a 5 and 1 rating is 3    
    assert_equal 3, Recipe.find(@recipe.id).average_rating
  end
  
  test "after destroy of review, average_rating of parent recipe should be updated" do
    # save two reviews to a recipe
    @recipe.reviews << @review
    @review_two = users(:archer).reviews.build(rating: 1, content: "A bad review", recipe_id: @recipe.id)
    @recipe.reviews << @review_two
    @recipe.save
    assert_equal 3, Recipe.find(@recipe.id).average_rating
    # destroy a review and ensure the updated recipe.average_rating
    @review_two.destroy
    assert_equal 5, Recipe.find(@recipe.id).average_rating
  end 
end
