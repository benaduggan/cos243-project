class SessionsController < ApplicationController

  def new
  end
  
  def create
    @user = User.find_by_username(params[:username])
    if @user && @user.authenticate(params[:password])
      cookies[:user_id] = @user.id
      flash[:success] = "You are now logged in #{@user.username}!"
      redirect_to @user
    else
      flash.now[:danger] = "invalid username or password"
      render 'new'
    end
  end
  
  def destroy
    
  end

end
