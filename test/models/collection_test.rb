require 'test_helper'

class CollectionTest < ActiveSupport::TestCase
  
  def setup
    @collection = collections(:one)
  end

  test "should be valid" do
    assert @collection.valid?
  end
  
  test "user_id should be present" do
    @collection.user_id = nil
    assert_not @collection.valid?
  end
  
  test "name should be present" do
    @collection.name = " "
    assert_not @collection.valid?
  end
  
  test "name should be less than 130 characters" do
    @collection.name = "x" * 131
    assert_not @collection.valid?
  end 
  
  test "blank description should be allowed" do
    @collection.description = "  "
    assert @collection.valid?
  end 
  
  test "description should be less than 1000 characters" do 
    @collection.description = "x" * 1001
    assert_not @collection.valid?
  end 
  
  test "featured should be true/false" do 
    @collection.featured = true
    assert @collection.valid?
    @collection.featured = false
    assert @collection.valid?
    @collection.featured = nil
    assert_not @collection.valid?
  end 
  
  test "should be able to have an image" do 
    @collection.image = fixture_file_upload('/files/right_size.jpg', 'image/jpg')
    assert(File.exists?(@collection.reload.image.file.path))
  end 
  
  test "should not be able to upload a image over 5 megabytes" do
    @collection.image = fixture_file_upload('/files/too_large.jpg', 'image/jpg')
    assert_not @collection.valid?
  end
  
  test "should have a square version of image" do
    @collection.image = fixture_file_upload('/files/right_size.jpg', 'image/jpg')
    assert @collection.image.url(:square).end_with?("square_right_size.jpg")
  end
  
end
