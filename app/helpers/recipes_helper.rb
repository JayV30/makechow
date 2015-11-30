module RecipesHelper
  
  # Returns true if the current user has already favorited the recipe
  def existing_favorite?(recipe)
    !current_user.favorites.find_by(id: recipe.id).nil?
  end 
  
  # Returns the average rating
  def avg_rating(recipe)
    if recipe.reviews.any?
      review_count = recipe.reviews.size
      total_rating = 0
      recipe.reviews.each { |review| 
        total_rating += review.rating
      }
      total_rating.to_f / review_count
    else
      0
    end
  end
  
end
