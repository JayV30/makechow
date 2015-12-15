class Collection < ActiveRecord::Base
  has_and_belongs_to_many :recipes
  belongs_to :user, counter_cache: true
  
  mount_uploader :image, ImageUploader
  
  validates :user_id, presence: true
  validates :name, presence: true, length: { maximum: 130 }
  validates :description, allow_blank: true, length: { maximum: 1000 }
  validates :featured, inclusion: { in: [true, false] }
  validate :image_size
  
  private
  
    # Validates size of an uploaded image
    def image_size
      if image.size > 5.megabytes
        errors.add(:image, "should be less than 5MB")
      end
    end
    
end
