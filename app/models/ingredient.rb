class Ingredient < ActiveRecord::Base
  belongs_to :recipe
  
  validates :name, presence: true, length: { maximum: 130 }
  validates :quantity, presence: true, length: { maximum: 80 }
end
