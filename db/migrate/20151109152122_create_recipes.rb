class CreateRecipes < ActiveRecord::Migration
  def change
    create_table :recipes do |t|
      t.string :title
      t.text :description
      t.string :image_url
      t.integer :prep_time
      t.integer :cook_time
      t.string :servings
      
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
    
  end
end
