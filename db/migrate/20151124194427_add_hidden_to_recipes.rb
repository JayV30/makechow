class AddHiddenToRecipes < ActiveRecord::Migration
  def change
    add_column :recipes, :hidden, :boolean, default: false
  end
end
