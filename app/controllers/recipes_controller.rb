class RecipesController < ApplicationController
  include RecipesHelper
  before_action :logged_in_user, only: [:new, :create, :edit, :update, :destroy, :favorite]
  before_action :recipe_owner, only: [:edit, :update, :destroy]
  before_action :hidden_recipe, only: [:show]
  
  def index
    @recipes = Recipe.search(params[:search]).paginate(page: params[:page], per_page: 12)
    filtering_params(params).each do |key, value|
      @recipes = @recipes.public_send(key, value) if value.present?
    end
  end
  
  def show
    @recipe = Recipe.find(params[:id])
    @steps = @recipe.steps.all
    @ingredients = @recipe.ingredients.all
    @reviews = @recipe.reviews.limit(6)
    if logged_in?
      @review = current_user.reviews.find_by(recipe_id: params[:id]) || current_user.reviews.build
    end
  end
  
  def new
    @recipe = Recipe.new
    @recipe.steps.build(step_number: 0) # needed to display form field
    @recipe.ingredients.build # needed to display form field
  end
  
  def create
    @recipe = current_user.recipes.build(recipe_params)
    if @recipe.save
      flash[:success] = "Recipe created!"
      redirect_to @recipe
    else
      render 'new'
    end
  end
  
  def edit 
    @recipe = Recipe.find(params[:id])
    @recipe.steps.build(step_number: 0) if @recipe.steps.empty? # need at least one instance to display form field
    @recipe.ingredients.build if @recipe.ingredients.empty? # need at least one instance to display form field
  end
  
  def update
    @recipe = Recipe.find(params[:id])
    if @recipe.update_attributes(recipe_params)
      flash[:success] = "Recipe updated"
      redirect_to @recipe
    else
      render 'edit'
    end
  end
  
  def destroy
    Recipe.find(params[:id]).destroy
    flash[:success] = "Recipe deleted"
    redirect_to request.referrer || current_user
  end
  
  def favorite
    @recipe = Recipe.find(params[:id])
    if existing_favorite?(@recipe)
      current_user.favorites.delete(@recipe)
      flash[:success] = "Removed from Favorites"
      redirect_to @recipe
    else
      current_user.favorites << @recipe
      flash[:success] = "Saved to Favorites"
      redirect_to @recipe 
    end
  end
  
  def popular
    @recipes = Recipe.popular.paginate(page: params[:page], per_page: 12)
    filtering_params(params).each do |key, value|
      @recipes = @recipes.public_send(key, value) if value.present?
    end
  end
  
  def latest
    @recipes = Recipe.latest.paginate(page: params[:page], per_page: 12)
    filtering_params(params).each do |key, value|
      @recipes = @recipes.public_send(key, value) if value.present?
    end
  end
  
  def quick
    @recipes = Recipe.quick.paginate(page: params[:page], per_page: 12)
    filtering_params(params).each do |key, value|
      @recipes = @recipes.public_send(key, value) if value.present?
    end
  end
  
  private
  
    def recipe_params
      params.require(:recipe).permit(:title, :description, :cook_time, :prep_time, :image_url, :remove_image_url, :servings, :hidden, :cuisine, :course,:category, :average_rating, steps_attributes: [:id, :step_number, :content, :_destroy], ingredients_attributes: [:id, :name, :quantity, :_destroy])
    end
    
    def filtering_params(params)
      params.slice(:category, :cuisine, :course, :sort_by)
    end
    
    def recipe_owner
      recipe = current_user.recipes.find_by(id: params[:id])
      unless current_user.admin?
        if recipe.nil?
          flash[:danger] = "Cannot modify another users recipes"
          redirect_to root_url
        end
      end
    end
    
    def hidden_recipe
      recipe = Recipe.find(params[:id])
      unless logged_in? && (recipe.user_id == current_user.id)
        if recipe.hidden == true
          flash[:danger] = "This recipe is private"
          redirect_to root_url
        end
      end
    end
  
end
