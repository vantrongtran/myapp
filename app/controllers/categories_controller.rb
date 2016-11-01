class CategoriesController < ApplicationController
  before_action :logged_in_user, only: :index
  def index
    @categories = Category.order(created_at: :desc)
      .paginate page: params[:page], per_page: Settings.per_page
    @lesson = Lesson.new
  end
end
