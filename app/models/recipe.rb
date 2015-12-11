class Recipe < ActiveRecord::Base
  belongs_to :user
  has_and_belongs_to_many :collections
  has_many :reviews, dependent: :destroy
  has_many :steps, dependent: :destroy
  has_many :ingredients, dependent: :destroy
  
  # Users that have favorited
  has_many :favorite_recipes
  has_many :favorited_by, through: :favorite_recipes, source: :user, dependent: :destroy
  
  accepts_nested_attributes_for :steps, allow_destroy: true, reject_if: :all_blank
  accepts_nested_attributes_for :ingredients, allow_destroy: true, reject_if: :all_blank
  
  mount_uploader :image_url, ImageUploader
  before_save :set_total_time
  
  scope :popular, -> { where(["average_rating > :average_rating", average_rating: "3.2"]).not_private }
  scope :latest, -> { where(["created_at > :created_at", created_at: 5.days.ago]).not_private }
  scope :quick, -> { where(["total_time <= :total_time", total_time: "30"]).not_private }
  scope :not_private, -> { where.not(hidden: true) }
  scope :sort_by, ->(symbol) do
    case symbol
      when "Rating"
        order average_rating: :desc
      when "Date (default)"
        order created_at: :desc 
      when "Time to Make"
        order total_time: :asc
    end
  end
  scope :category, ->(category) { where(category: category) }
  scope :cuisine, ->(cuisine) { where(cuisine: cuisine) }
  scope :course, ->(course) { where(course: course) }
  
  CATEGORY_OPTIONS = ["Breakfast", "Brunch", "Lunch", "Dinner"]
  COURSE_OPTIONS = ["Appetizer", "Beverage", "Bread", "Dessert", "Finger food", "Main dish", "Salad", "Side dish", "Snack", "Soup and stew"]
  CUISINE_OPTIONS = ["American", "Argentine", "Australian", "Brazilian", "Canadian", "Caribbean", "Central American", "Chinese", "English", "Ethiopian", "French", "German", "Greek", "Indian", "Irish", "Italian", "Jewish", "Korean", "Mexican", "Moroccan", "Native American", "Persian", "Polish", "Portuguese", "Russian", "Scandinavian", "South Pacific", "Spanish", "Thai", "Turkish", "Vietnamese"]
  SORTING_OPTIONS = ["Date (default)", "Rating", "Time to Make" ]

  validates :user_id, presence: true
  validates :title, presence: true, length: { maximum: 130 }
  validates :description, presence: true
  validates :prep_time, presence: true, numericality: { only_integer: true, greater_than: -1 }
  validates :cook_time, presence: true, numericality: { only_ingeter: true, greater_than: -1 }
  validates :servings, presence: true, length: { maximum: 80 }
  validates :hidden, inclusion: { in: [true, false] }
  validate :image_size
  validates :category, presence: true, inclusion: { in: CATEGORY_OPTIONS }
  validates :course, presence: true, inclusion: { in: COURSE_OPTIONS }
  validates :cuisine, presence: true, inclusion: { in: CUISINE_OPTIONS }
  validates :average_rating, presence: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 5 }
  
  def self.search(value)
    if value
      if Rails.env.production?
        where(['(title ILIKE :search_term OR description ILIKE :search_term)', search_term: "%" + value + "%" ]).not_private
      else
        where(['(title LIKE :search_term OR description LIKE :search_term OR id LIKE :search_term)', search_term: "%" + value + "%" ]).not_private
      end
    else
      not_private
    end
  end
  
  private
  
    # Validates size of an uploaded image
    def image_size
      if image_url.size > 5.megabytes
        errors.add(:image_url, "should be less than 5MB")
      end
    end
    
    def set_total_time
      self.total_time = prep_time + cook_time
    end
    
end
