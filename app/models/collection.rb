class Collection < ActiveRecord::Base
  has_and_belongs_to_many :recipes
  belongs_to :user, counter_cache: true
  
  mount_uploader :image, ImageUploader
  
  validates :name, presence: true, length: { maximum: 130 }
  validates :description, allow_blank: true, length: { maximum: 1000 }
  validates :user_id, presence: true
  validates :featured, inclusion: { in: [true, false] }
  
end
