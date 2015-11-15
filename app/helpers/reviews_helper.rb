module ReviewsHelper
  
  # returns true if current user already has a review for the given recipe
  def review_exists?(recipe)
    !recipe.reviews.find_by(user_id: current_user.id).nil?
  end
end
