class WordsController < ApplicationController
  before_action :logged_in_user
  def index
    @categories = Category.all
    if params[:category_id] && params[:word_filter] && params[:word_search]
      @words = Word.includes(:answers).filter_category(params[:category_id])
        .send(params[:word_filter], current_user.id, params[:word_search])
        .paginate page: params[:page], per_page: Settings.per_page
    else
      @words = Word.includes(:answers)
        .paginate page: params[:page], per_page: Settings.per_page
    end
  end
end
