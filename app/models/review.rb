class Review < ActiveRecord::Base
  belongs_to :recipe
  belongs_to :user
  
  default_scope -> { order(created_at: :desc) }
  
  validates :user_id, presence: true
  validates :recipe_id, presence: true
  validates :rating, presence: true, numericality: { only_integer: true, greater_than: -1, less_than: 5 }
  validates :content, allow_blank: true, length: { maximum: 1000 }
  
end
