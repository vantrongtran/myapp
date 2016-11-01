class Admin::UsersController < ApplicationController
  before_action :logged_in_user, only: :index
  before_action :load_user, only: [:destroy, :show]
  before_action :verify_admin, only: :index

  def index
    if params[:key]
      @users = User.user.search params[:key]
      respond_to do |format|
        format.json do
          render json: @users
        end
      end
    elsif params[:search]
      @users = User.user.search(params[:search]).
        paginate page: params[:page],
        per_page: Settings.per_page
    else
      @users = User.user.paginate page: params[:page],
        per_page: Settings.per_page
    end
  end

  def show

  end

  def destroy
    respond_to do |format|
      if @user.destroy
        format.json do
          render json: {status: t("delete_success")}
        end
      else
        format.json do
          render json: {status: t("delete_failed")}
        end
      end
    end
  end
end
