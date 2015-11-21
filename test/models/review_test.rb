require 'test_helper'

class ReviewTest < ActiveSupport::TestCase
  
  def setup
    @review = reviews(:review_one)
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
end
