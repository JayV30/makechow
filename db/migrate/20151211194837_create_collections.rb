class CreateCollections < ActiveRecord::Migration
  def change
    create_table :collections do |t|
      t.string :name
      t.text :description
      t.string :image
      t.boolean :featured, default: false

      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
