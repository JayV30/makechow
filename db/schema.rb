# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20151124134116) do

  create_table "favorite_recipes", force: :cascade do |t|
    t.integer  "recipe_id"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ingredients", force: :cascade do |t|
    t.string   "name"
    t.string   "quantity"
    t.integer  "recipe_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "ingredients", ["recipe_id"], name: "index_ingredients_on_recipe_id"

  create_table "recipes", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.string   "image_url"
    t.integer  "prep_time"
    t.integer  "cook_time"
    t.string   "servings"
    t.integer  "user_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "recipes", ["user_id"], name: "index_recipes_on_user_id"

  create_table "recipes_users", id: false, force: :cascade do |t|
    t.integer "recipe_id"
    t.integer "user_id"
  end

  add_index "recipes_users", ["recipe_id"], name: "index_recipes_users_on_recipe_id"
  add_index "recipes_users", ["user_id"], name: "index_recipes_users_on_user_id"

  create_table "reviews", force: :cascade do |t|
    t.integer  "rating"
    t.text     "content"
    t.integer  "recipe_id"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "reviews", ["recipe_id"], name: "index_reviews_on_recipe_id"
  add_index "reviews", ["user_id"], name: "index_reviews_on_user_id"

  create_table "steps", force: :cascade do |t|
    t.integer  "step_number"
    t.text     "content"
    t.integer  "recipe_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "steps", ["recipe_id", "step_number"], name: "index_steps_on_recipe_id_and_step_number"
  add_index "steps", ["recipe_id"], name: "index_steps_on_recipe_id"

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.string   "password_digest"
    t.string   "remember_digest"
    t.string   "location"
    t.string   "image_url"
    t.boolean  "admin",             default: false
    t.string   "activation_digest"
    t.boolean  "activated",         default: false
    t.datetime "activated_at"
    t.string   "reset_digest"
    t.datetime "reset_sent_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true

end
