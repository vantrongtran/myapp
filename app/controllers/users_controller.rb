class UsersController < ApplicationController
  before_action :logged_in_user, only: [:edit, :update]
  before_action :load_user, only: [:show, :edit, :update]
  before_action :correct_user, only: [:edit, :update]

  def index
    @users = User.user.search(params[:search_users]).
      paginate page: params[:page],
      per_page: Settings.per_page
  end

  def show
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      log_in @user
      flash[:success] = t "register_success"
      redirect_to @user
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @user.update_attributes user_params
      flash[:success] = t "update_success"
      redirect_to @user
    else
      render :edit
    end
  end

  private
  def user_params
    params.require(:user).permit :name, :email, :password,
      :password_confirmation
  end
end
