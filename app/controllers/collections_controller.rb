class CollectionsController < ApplicationController
  before_action :logged_in_user, only: [:new, :create, :edit, :update, :destroy, :admin_view]
  before_action :admin_user, only: [:new, :create, :edit, :update, :destroy, :admin_view]
  
  def index
  end
  
  def show
    @collection = Collection.find(params[:id])
  end
  
  def new
    @collection = Collection.new
  end

  def create
    @collection = current_user.collections.build(collection_params)
    if @collection.save
      flash[:success] = "Collection created - add recipes via edit button"
      redirect_to admin_view_collections_path
    else
      render 'new'
    end
  end
  
  def edit
    @collection = Collection.find(params[:id])
    @recipes = Recipe.search(params[:search]).paginate(page: params[:page])
    filtering_params(params).each do |key, value|
      @recipes = @recipes.public_send(key, value) if value.present?
    end
  end
  
  def update
    @collection = Collection.find(params[:id])
    if @collection.update_attributes(collection_params)
      flash[:success] = "Collection updated"
      redirect_to @collection
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
  
  private
  
    def collection_params
      params.require(:collection).permit(:name, :description, :featured, :image, :remove_image)
    end
    
    def filtering_params(params)
      params.slice(:category, :cuisine, :course, :sort_by)
    end
  

end
