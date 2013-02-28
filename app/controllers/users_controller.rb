class UsersController < ApplicationController
  before_filter :signed_in_user, only: [:show, :edit, :update]
  before_filter :correct_user,   only: [:show, :edit, :update]

  #GET /users/1  user_path(user)
  def show
    @user = User.find(params[:id])
  end

  #GET /users/new  new_user_path
  def new
    @user = User.new
  end

  #POST /users users_path
  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to catchup!"
      redirect_to @user
    else
      render 'new'
    end
  end

  #GET /users/1/edit edit_user_path(user)
  def edit
  end

  #PUT /users/1  user_path(user)
  def update
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated"
      sign_in @user
      redirect_to @user
    else
      render 'edit'
    end
  end

  private

    def signed_in_user
      redirect_to signin_url, notice: "Please sign in." unless signed_in?
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end
end
