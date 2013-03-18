class UsersController < ApplicationController
  before_filter :signed_in_user, only: [:show, :edit, :update]
  before_filter :correct_user,   only: [:edit, :update]
  before_filter :signed_in_user_filter, only: [:new, :create]

  #GET /users - users_path - page to list all users
  def index

  end

  #GET /users/1 - user_path(user) - page to show user with id 1
  def show
    # puts("bbbbbbbbllllllaaaaaa!!!!!!!!")
    @user = User.find(params[:id])
    @infos = @user.infos
  end

  #GET /users/new - new_user_path - page to make a new user
  def new
    @user = User.new
  end

  #POST /users - users_path - creates a new user
  def create
    @user = User.new(params[:user])
    @user.create_remember_token
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to catchup!"
      redirect_to @user
    else
      render 'new'
    end
  end

  #GET /users/1/edit - edit_user_path(user) - page to edit user with id 1
  def edit
  end

  #PUT /users/1  user_path(user) - update user with id 1
  def update
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated"
      sign_in @user
      redirect_to @user
    else
      render 'edit'
    end
  end

  #DELETE /users/1 - user_path(user) - delete user
  def destroy

  end

  def show_contacts
    @contacts = current_user.contacts
  end


  private

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end

    def signed_in_user_filter
      redirect_to root_path, notice: "Already logged in." if signed_in?
    end
end
