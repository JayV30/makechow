class Recipe < ActiveRecord::Base
  belongs_to :user
  #belongs_to :category
  has_many :reviews, dependent: :destroy
  has_many :steps, dependent: :destroy
  has_many :ingredients, dependent: :destroy
  
  # Users that have favorited
  has_many :favorite_recipes
  has_many :favorited_by, through: :favorite_recipes, source: :user, dependent: :destroy
  
  accepts_nested_attributes_for :steps, allow_destroy: true, reject_if: :all_blank
  accepts_nested_attributes_for :ingredients, allow_destroy: true, reject_if: :all_blank
  
  mount_uploader :image_url, ImageUploader
  
  default_scope -> { order(created_at: :desc) }
  
  COURSE_OPTIONS = ["appetizer", "beverage", "bread", "dessert", "finger food", "main dish", "salad", "side dish", "snack", "soup and stew"]
  CUISINE_OPTIONS = ["American", "Argentine", "Australian", "Brazilian", "Canadian", "Caribbean", "Central American", "Chinese", "English", "Ethiopian", "French", "German", "Greek", "Indian", "Irish", "Italian", "Jewish", "Korean", "Mexican", "Moroccan", "Native American", "Persian", "Polish", "Portuguese", "Russian", "Scandinavian", "South Pacific", "Spanish", "Thai", "Turkish", "Vietnamese"]

  validates :user_id, presence: true
  validates :title, presence: true, length: { maximum: 130 }
  validates :description, presence: true
  validates :prep_time, presence: true, numericality: { only_integer: true, greater_than: -1 }
  validates :cook_time, presence: true, numericality: { only_ingeter: true, greater_than: -1 }
  validates :servings, presence: true, length: { maximum: 80 }
  validates :hidden, inclusion: { in: [true, false] }
  validate :image_size
  validates :course, presence: true, inclusion: { in: COURSE_OPTIONS }
  validates :cuisine, presence: true, inclusion: { in: CUISINE_OPTIONS }
  validates :average_rating, presence: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 5 }
  
  def self.search(value)
    if value
      if Rails.env.production?
        where(['(title ILIKE :search_term OR description ILIKE :search_term) AND hidden != :hidden', search_term: "%" + value + "%", hidden: "t" ])
      else
        where(['(title LIKE :search_term OR description LIKE :search_term OR id LIKE :search_term) AND hidden != :hidden', search_term: "%" + value + "%", hidden: "t"])
      end
    else
      where.not(["hidden = ?", "t"])
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
