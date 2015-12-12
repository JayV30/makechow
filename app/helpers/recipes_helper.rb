module RecipesHelper
  
  # Returns true if the current user has already favorited the recipe
  def existing_favorite?(recipe)
    !current_user.favorites.find_by(id: recipe.id).nil?
  end 
  
  # Return true if the recipe is already in the collection
  def in_collection?(collection, recipe)
    !collection.recipes.find_by(id: recipe.id).nil?
  end
  
  # Returns the given integer as a string formatted as hrs/mins
  def hours_and_minutes(number)
    hours = number/60 == 0 ? nil : pluralize(number/60, "hr", "hrs")
    minutes = number%60 == 0 ? nil : pluralize(number%60, "min", "mins")
    if hours && minutes
      hours + " " + minutes
    elsif hours
      hours
    elsif minutes
      minutes
    else
      ""
    end
  end
  
end
