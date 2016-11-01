class Admin::CategoriesController < ApplicationController
  before_action :logged_in_user
  before_action :verify_admin
  before_action :load_category, only: [:destroy, :edit, :update]

  def index
    if params[:key]
      @categories = Category.search params[:key]
      respond_to do |format|
        format.json do
          render json: @categories
        end
      end
    elsif params[:category_search]
      @categories = Category.search(params[:category_search]).
        paginate page: params[:page],
        per_page: Settings.per_page
    else
      @categories = Category.all.paginate page: params[:page],
        per_page: Settings.per_page
    end
    @category = Category.new
  end

  def edit
  end

  def new
  end

  def create
    @category = Category.new category_params
    if @category.save
      respond_to do |format|
        format.html do
          flash[:success] = t "create_success"
          redirect_to admin_categories_path
        end
        format.json do
          render json: @category
        end
      end
    else
      flash[:danger] = t "create_failed"
      redirect_to admin_categories_path
    end
  end

  def update
    if @category.update_attributes category_params
      flash[:success] = t "update_success"
      redirect_to admin_categories_path
    else
      flash[:danger] = t "update_failed"
      render :edit
    end
  end

  def destroy
    respond_to do |format|
      if @category.verify_destroy?
        @category.destroy
        format.json do
          render json: {status: @category.destroyed?}
        end
      end
    end
  end

  private

  def category_params
    params.require(:category).permit :name, :description
  end

  def load_category
    @category = Category.find_by id: params[:id]
    if @category.nil?
      flash[:danger] = t "category_not_found"
      redirect_to admin_categories_path
    end
  end
end
