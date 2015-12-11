class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: [:index, :destroy]
  
  def index
    @users = User.paginate(page: params[:page])
  end
  
  def show
    @user = User.find(params[:id])
    unless @user.activated? || current_user.admin?
      redirect_to root_url and return
    end
    if logged_in? && current_user?(@user)
      @recipes = @user.recipes.order(created_at: :desc).paginate(page: params[:recipe_page], per_page: 8)
    else
      @recipes = @user.recipes.where.not(hidden: true).order(created_at: :desc).paginate(page: params[:recipe_page], per_page: 8)
    end
    @reviews = @user.reviews.order(created_at: :desc).paginate(page: params[:review_page], per_page: 6)
    @favorites = @user.favorites.order(created_at: :desc).paginate(page: params[:favorite_page], per_page: 8)
    @creation_date = @user.created_at.strftime("%Y")
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
    else
      render 'new'
    end
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def update 
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end
  
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end
  
  private
  
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :location, :image_url, :remove_image_url)
    end
    
    # Confirms the correct user
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end
  
end
