class Recipe < ActiveRecord::Base
  belongs_to :user
  #belongs_to :category
  #has_many :reviews, dependent: :destroy
  #has_many :steps, dependent: :destroy
  #has_and_belongs_to_many :ingredients
  default_scope -> { order(created_at: :desc) }
  
  VALID_URL_REGEX = /(\A|\s)((https?:\/\/)?[\w-]+(\.[\w-]+)+\.?(:\d+)?(\/\S*)?)/i
  validates :user_id, presence: true
  validates :title, presence: true, length: { maximum: 80 }
  validates :description, presence: true
  validates :prep_time, presence: true, numericality: { only_integer: true, greater_than: -1 }
  validates :cook_time, presence: true, numericality: { only_ingeter: true, greater_than: -1 }
  validates :servings, presence: true, length: { maximum: 60 }
  validates :image_url, allow_blank: true, length: { maximum: 255 }, format: { with: VALID_URL_REGEX }
  
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
    
end
