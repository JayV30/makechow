class CreateSteps < ActiveRecord::Migration
  def change
    create_table :steps do |t|
      t.integer :step_number
      t.text :content
      t.references :recipe, index: true, foreign_key: true

      t.timestamps null: false
    end
    add_index :steps, [:recipe_id, :step_number]
  end
end
