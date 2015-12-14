class CollectionsController < ApplicationController
  include RecipesHelper
  before_action :logged_in_user, only: [:new, :create, :edit, :update, :destroy, :admin_view, :remove_from_collection]
  before_action :admin_user, only: [:new, :create, :edit, :update, :destroy, :admin_view, :remove_from_collection]
  
  def index
    @collections = Collection.where(featured: true)
    @recipe = Recipe.popular.order("RANDOM()").first
    @category = Recipe::CATEGORY_OPTIONS.sample
    @category_recipes = Recipe.category(@category).not_private.sort_by("Rating").limit(3)
    @cuisine = Recipe::CUISINE_OPTIONS.sample
    @cuisine_recipes = Recipe.cuisine(@cuisine).not_private.sort_by("Rating").limit(3)
    @course = Recipe::COURSE_OPTIONS.sample
    @course_recipes = Recipe.course(@course).not_private.sort_by("Rating").limit(3)
  end
  
  def show
    @collection = Collection.find(params[:id])
    @recipes = @collection.recipes.paginate(page: params[:page])
  end
  
  def new
    @collection = Collection.new
  end

  def create
    @collection = current_user.collections.build(collection_params)
    if @collection.save
      flash[:success] = "Collection created - add recipes"
      redirect_to admin_view_recipes_path
    else
      render 'new'
    end
  end
  
  def edit
    @collection = Collection.find(params[:id])
  end
  
  def update
    @collection = Collection.find(params[:id])
    if @collection.update_attributes(collection_params)
      flash[:success] = "Collection updated"
      redirect_to admin_view_collections_path
    else
      render 'edit'
    end
  end
  
  def destroy
    Collection.find(params[:id]).destroy
    flash[:success] = "Collection deleted"
    redirect_to request.referrer || admin_view_collections_path
  end
  
  def admin_view
    @collections = Collection.paginate(page: params[:page])
  end
  
  def remove_from_collection
    @collection = Collection.find(params[:id])
    @recipe = Recipe.find(params[:recipe])
    if in_collection?(@collection, @recipe)
      @collection.recipes.delete(@recipe)
      flash[:success] = "Removed from Collection"
      redirect_to edit_collection_path(@collection)
    else
      flash[:danger] = "Error removing Recipe from Collection"
      redirect_to edit_collection_path(@collection)
    end
  end
  
  private
  
    def collection_params
      params.require(:collection).permit(:name, :description, :featured, :image, :remove_image)
    end
  
end
