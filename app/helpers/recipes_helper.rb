module RecipesHelper
  
  # Returns true if the current user has already favorited the recipe
  def existing_favorite?(recipe)
    !current_user.favorites.find_by(id: recipe.id).nil?
  end 
  
end
