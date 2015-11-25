class AddCourseAndCusineToRecipes < ActiveRecord::Migration
  def change
    add_column :recipes, :course, :string
    add_column :recipes, :cuisine, :string
  end
end
