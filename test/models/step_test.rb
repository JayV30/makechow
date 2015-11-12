require 'test_helper'

class StepTest < ActiveSupport::TestCase
  
  def setup
    @user = users(:michael)
    @recipe = @user.recipes.build( title: "Chocolate Cake", description: "Delicious and Mouth Watering", prep_time: 10, cook_time: 10, servings: "2 servings")
    @step = @recipe.steps.build( step_number: 1, content: "Prepare the ingredients.")
    @step2 = @recipe.steps.build( step_number: 2, content: "Cook the preperation.")
  end
  
  test "should be valid" do
    assert @step.valid?
  end
  
  test "step_number should be present" do 
    @step.step_number = nil
    assert_not @step.valid?
  end
  
  test "content should be present" do 
    @step.content = nil
    assert_not @step.valid?
  end
  
  test "step_number should be an integer greater than 0" do
    @step.step_number = -2
    assert_not @step.valid?
  end
  
  test "content should be less than 10,000 characters" do
    @step.content = "x" * 10002
    assert_not @step.valid?
  end
  
  test "should be ordered by step_number" do
    assert_equal steps(:first), Step.first
    assert_equal steps(:one), Step.second
  end
end
