class UsersController < ApplicationController

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
end
