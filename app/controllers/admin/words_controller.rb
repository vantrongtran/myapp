class Admin::WordsController < ApplicationController
  before_action :logged_in_user
  before_action :verify_admin
  before_action :load_word, only: [:destroy, :edit, :update]

  def index
    if params[:key]
      @words = Word.includes(:category).search params[:key]
      respond_to do |format|
        format.json do
          render json: @words
        end
      end
    elsif params[:search]
      @words = Word.includes(:category).search params[:search].paginate page: params[:page],
        per_page: Settings.per_page
    else
      @words = Word.includes(:category).paginate page: params[:page],
        per_page: Settings.per_page
      @word = Word.new
      @word.answers.new
      @categories = Category.all
    end
  end

  def new
  end

  def create
    @word = Word.create word_params
    if @word.save
      respond_to do |format|
        format.html do
          flash[:success] = t "create_success"
          redirect_to admin_words_path
        end
        format.json do
          render json: @word
        end
      end
    else
      flash[:danger] = t "create_failed"
      redirect_to admin_words_path
    end
  end

  def edit
    @categories = Category.all
  end

  def update
    if @word.update_attributes word_params
      flash[:success] = t "update_success"
      redirect_to admin_words_path
    else
      flash[:danger] = t "update_failed"
    end
  end

  def destroy
    if @word.destroy
      respond_to do |format|
        format.json do
          render json: {status: @word.destroyed?}
        end
      end
    else
      flash[:danger] = t "delete_failed"
      redirect_to admin_words_path
    end
  end

  private

  def load_word
    @word = Word.find_by id: params[:id]
    unless @word
      flash[:danger] = t "word_not_exist"
      redirect_to admin_words_path
    end
  end

  def word_params
    params.require(:word).permit :content, :category_id,
      answers_attributes: [:id, :content, :is_correct]
  end
end
