class AddReviewsCountToRecipes < ActiveRecord::Migration
  def change
    add_column :recipes, :reviews_count, :integer
  end
end
