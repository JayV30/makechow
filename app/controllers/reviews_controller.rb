class ReviewsController < ApplicationController
  before_action :logged_in_user, only: [:create, :update, :destroy]
  before_action :review_owner, only: [:update, :destroy]
  
  def create
    @review = current_user.reviews.build(review_params)
    if @review.save
      flash[:success] = "Review created!"
      redirect_to @review.recipe
    else
      flash[:danger] = "There was a problem saving your review. Please try again."
      redirect_to @review.recipe
    end
  end
  
  def update
    if @review.update_attributes(review_params)
      flash[:success] = "Review updated"
      redirect_to @review.recipe
    else
      flash[:danger] = "There was a problem updating your review. Please try again."
      redirect_to @review.recipe
    end
  end
  
  def destroy
    id = @review.id
    @review.destroy
    flash[:success] = "Review deleted"
    redirect_to recipe_path(id)
  end
  
  private
  
    def review_params
      params.require(:review).permit(:rating, :content, :recipe_id)
    end
    
    def review_owner
      @review = current_user.reviews.find_by(id: params[:id])
      unless current_user.admin?
        if @review.nil?
          flash[:danger] = "Cannot modify another users reviews"
          redirect_to root_url
        end
      end
    end
    
end