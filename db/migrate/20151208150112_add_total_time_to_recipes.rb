class AddTotalTimeToRecipes < ActiveRecord::Migration
  def change
    add_column :recipes, :total_time, :integer
  end
end
