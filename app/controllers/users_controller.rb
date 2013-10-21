class UsersController < ApplicationController
  before_action :user_logged_in, only: [:edit, :update]
  before_action :ensure_correct_user, only: [:edit, :update]
  before_action :ensure_admin_user, only: [:destroy]
  
  def index
    @users = User.all
  end
  
  def new
    if logged_in?
      redirect_to root_path
    else
      @user = User.new
    end
  end
  
  def create
    if logged_in?
      redirect_to root_path
    else
      @user = User.new(permittedparams)
    
      if @user.save then
        flash[:success] = "Welcome to the site #{@user.username}! You are now logged in!"
        logIn(@user)
        redirect_to @user
      else
        render 'new'
      end
    end
  end
  
  def show
    @user = User.find(params[:id])
  end

  def edit 
  end
    
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(permittedparams)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    @user = User.find(params[:id])
    if @user.admin?
      redirect_to root_path
    else
      @user.destroy
      flash[:success] = "User successfully deleted!"
      redirect_to users_path      
    end
  end
    
    
  private
    def permittedparams
      permittedparams = params.require(:user).permit(:username,:password,:password_confirmation,:email)
    end    
    
    def user_logged_in
      redirect_to login_path unless logged_in?
    end
    
    def ensure_correct_user
      @user = User.find(params[:id])
      redirect_to root_path unless current_user?(@user)
    end
    
    def ensure_admin_user
      redirect_to users_path unless current_user.admin?
    end
end