class Review < ActiveRecord::Base
  belongs_to :recipe, counter_cache: true
  belongs_to :user
  after_save :update_recipe
  after_destroy :update_recipe
  
  default_scope -> { order(created_at: :desc) }
  
  validates :recipe_id, presence: true
  validates :rating, presence: true, numericality: { only_integer: true, greater_than: 0, less_than: 6 }
  validates :content, allow_blank: true, length: { maximum: 1000 }


  private 
  
    def update_recipe
     average = recipe.reviews.average(:rating).to_f
     recipe.update_column(:average_rating, average)
    end
  
end