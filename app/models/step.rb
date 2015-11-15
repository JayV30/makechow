class Step < ActiveRecord::Base
  belongs_to :recipe
  
  default_scope -> { order(step_number: :asc) }
  
  validates :step_number, presence: true, numericality: { only_integer: true, greater_than: -1 }
  validates :content, presence: true, length: { maximum: 10000 } # prevent abuse
end
