class Recipe < ActiveRecord::Base
  belongs_to :user
  #belongs_to :category
  #has_many :reviews, dependent: :destroy
  has_many :steps, dependent: :destroy
  has_many :ingredients, dependent: :destroy
  accepts_nested_attributes_for :steps, allow_destroy: true, reject_if: :all_blank
  accepts_nested_attributes_for :ingredients, allow_destroy: true, reject_if: :all_blank
  
  mount_uploader :image_url, ImageUploader
  
  default_scope -> { order(created_at: :desc) }
  
  validates :user_id, presence: true
  validates :title, presence: true, length: { maximum: 130 }
  validates :description, presence: true
  validates :prep_time, presence: true, numericality: { only_integer: true, greater_than: -1 }
  validates :cook_time, presence: true, numericality: { only_ingeter: true, greater_than: -1 }
  validates :servings, presence: true, length: { maximum: 80 }
  validate :image_size
  
  def self.search(value)
    if value
      if Rails.env.production?
        where(['title ILIKE :search_term OR description ILIKE :search_term', search_term: "%" + value + "%"])
      else
        where(['title LIKE :search_term OR description LIKE :search_term OR id LIKE :search_term', search_term: "%" + value + "%"])
      end
    else
      all
    end
  end
  
  private
  
    # Validates size of an uploaded image
    def image_size
      if image_url.size > 5.megabytes
        errors.add(:image_url, "should be less than 5MB")
      end
    end
    
end
