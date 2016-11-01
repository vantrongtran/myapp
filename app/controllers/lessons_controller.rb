class LessonsController < ApplicationController

  before_action :logged_in_user
  before_action :load_lesson, only: [:edit, :update, :show]
  before_action :load_category, only: [:edit, :create, :update]

  def index
    @lessons = current_user.lessons.order(created_at: :desc)
      .paginate page: params[:page], per_page: Settings.per_page
  end
  def create
    @lesson = @category.lessons.build user: current_user
    if @lesson.save
      flash[:success] = t "start_lesson"
      current_user.create_activity Activity.action_types[:create_lesson],
        @lesson.id
      redirect_to edit_category_lesson_path @category.id, @lesson
    else
      flash[:danger] = t "create_failed"
      redirect_to categories_path
    end
  end

  def edit

  end

  def show
    @score = @lesson.results.correct_anwsers.size
    @results = @lesson.results.includes :word, :answer
  end

  def update
    if @lesson.update_attributes lesson_params
      flash[:success] = t "finish_lesson"
      current_user.create_activity Activity.action_types[:finish_lesson],
        @lesson.id
      redirect_to category_lesson_path @category, @lesson
    else
      flash[:danger] = t "dont_finish_message"
      redirect_to categories_path
    end
  end

  private
  def load_lesson
    @lesson = Lesson.find_by id: params[:id]
    unless @lesson
      flash[:danger] = t "lesson_not_found"
    end
  end
  def authorize_user_lesson
    unless current_user.current_user? @lesson.user
      flash[:danger] =  t "authorize_user_lesson_err"
      redirect_to root_url
    end
  end
  def load_category
    @category = Category.find_by id: params[:category_id]
    unless @category
      flash[:danger] = t "category_not_found"
      redirect_to categories_path
    end
  end
  def lesson_params
    params.require(:lesson).permit :category_id,
      results_attributes: [:id, :answer_id]
  end
end
