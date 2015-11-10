class RecipesController < ApplicationController
  before_action :logged_in_user, only: [:new, :create, :edit, :update, :destroy]
  
  def index
    @recipes = Recipe.search(params[:search]).paginate(page: params[:page], per_page: 8)
  end
  
  def show
  end
  
  def new
  end
  
  def create
    @recipe = current_user.recipes.build(recipe_params)
    if @recipe.save
      flash[:success] = "Recipe created!"
      redirect_to @recipe
    else
      render 'static_pages/home'
    end
  end
  
  def edit 
    @recipe = Recipe.find(params[:id])
  end
  
  def update
  end
  
  def destroy
  end
  
  private
  
    def recipe_params
      params.require(:recipe).permit(:title, :description, :cook_time, :prep_time, :image_url, :steps)
    end
end
