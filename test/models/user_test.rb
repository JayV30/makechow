require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    @user = User.new(name: "Example User", email: "user@example.com",
                     password: "foobar", password_confirmation: "foobar")
    @other_user = users(:michael)
    @no_image_user = users(:archer)
    @recipe = recipes(:chocolate)
  end

  test "should be valid" do
    assert @user.valid?
  end
  
  test "name should be present" do
    @user.name = "  "
    assert_not @user.valid?
  end

  test "email should be present" do
    @user.email = "   "
    assert_not @user.valid?
  end
  
  test "name should not be longer than 100 characters" do
    @user.name = "x" * 101
    assert_not @user.valid?
  end
  
  test "email should not be longer than 200 characters" do
    @user.email = "x" * 200 + "@foo.com"
    assert_not @user.valid?
  end
  
  test "email validation should accept valid addresses" do
    valid_addresses = %w[foo@bar.com testy+testerson@test.com first.last@name.com _should_be_valid@valid.email.org]
    valid_addresses.each do |address|
      @user.email = address
      assert @user.valid?, "#{address.inspect} should be valid"
    end
  end
  
  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[test@user,com foo.bar.org first.last@name. foo@us_fat.org user@name+inv.gov double@periods..com]
    invalid_addresses.each do |address|
      @user.email = address
      assert_not @user.valid?, "#{address.inspect} should be invalid"
    end
  end
  
  test "email address should be unique" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end
  
  test "email address should save as lowercase" do
    mixed_case_email = "ThIS-IS-an@EMAil.coM"
    @user.email = mixed_case_email
    @user.save
    assert_equal mixed_case_email.downcase, @user.reload.email
  end
  
  test "password should be present" do
    @user.password = @user.password_confirmation = " " * 6
    assert_not @user.valid?
  end
  
  test "password should have a minimum length" do
    @user.password = @user.password_confirmation = "x" * 5
    assert_not @user.valid?
  end
  
  test "should be able to have an image_url" do 
    assert File.exists?(@other_user.image_url.file.path)
    assert @other_user.valid?
  end
  
  test "should be able to upload a valid image_url" do
    @no_image_user.image_url = fixture_file_upload('/files/right_size.jpg', 'image/jpg')
    assert(File.exists?(@no_image_user.reload.image_url.file.path))
  end
  
  test "should not be able to upload a image over 5 megabytes" do
    @no_image_user.image_url = fixture_file_upload('/files/too_large.jpg', 'image/jpg')
    assert_not @no_image_user.valid?
  end
  
  test "should have a square version of image" do
    @no_image_user.image_url = fixture_file_upload('/files/right_size.jpg', 'image/jpg')
    assert @no_image_user.image_url.url(:square).end_with?("square_right_size.jpg")
  end
  
  test "authenticated? should return false for a user with nil digest" do
    assert_not @user.authenticated?(:remember, '')
  end
  
  test "associated recipes should be destroyed" do
    @user.save
    @user.recipes.create!(title: "Chocolate Cake", description: "Delicious",  image_url: "http://imgur.com/abc123.png", prep_time: 10, cook_time: 10, servings: "2 servings", category: "Breakfast", cuisine: "American", course: "Dessert")
    assert_difference "Recipe.count", -1 do
      @user.destroy
    end
  end
  
  test "associated reviews should be destroyed" do
    @user.save
    @user.reviews.create!(user_id: @other_user.id, recipe_id: @recipe.id, rating: 5, content: "five stars!")
    assert_difference "Review.count", -1 do
      @user.destroy
    end
  end
  
  test "associated collections should be destroyed" do
    @user.save
    @user.collections.create!(name: "Great Collection", description: "This is awesome")
    assert_difference "Collection.count", -1 do
      @user.destroy
    end 
  end
  
  test "should be able to favorite a recipe" do
    @user.save
    assert_difference "FavoriteRecipe.count", 1 do
      @user.favorites << @recipe
    end
  end
  
  test "associated entries in join table favorite_recipes should be destroyed" do
    @user.save
    @recipe.save
    @user.favorites << @recipe
    assert_difference "FavoriteRecipe.count", -1 do 
      @user.destroy
    end
  end
  
end