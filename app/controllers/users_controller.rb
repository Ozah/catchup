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
    # a password is created automatically because has_secure_password validates the presence of psw
    psw = SecureRandom.urlsafe_base64
    @user = User.new(params[:user].merge(password: psw, password_confirmation: psw))
    @user.create_remember_token
    if @user.save
      # @user.create_remember_token
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
    error = false
    # puts (params[:user][:password].to_s)
    #removes the psw and psw conf if the fields are empty
    if params[:user][:password].blank? && params[:user][:password_confirmation].blank?
      params[:user].delete(:password)
      params[:user].delete(:password_confirmation)
    else #the password is beeing reset
      if params[:user][:email].blank?
        flash[:error] = "Email cannot be empty when setting a password"
        error = true
      end
      if params[:user][:password].length < 6
        flash[:error] = "Password too short, minimum 5 characters"
        error = true
      end  
    end
    if @user.update_attributes(params[:user]) && !error
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
