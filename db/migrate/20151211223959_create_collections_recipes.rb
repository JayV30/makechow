class CreateCollectionsRecipes < ActiveRecord::Migration
  def change
    create_table :collections_recipes do |t|
      t.integer :collection_id
      t.integer :recipe_id
    end
  end
end
