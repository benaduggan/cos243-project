class RefereesController < ApplicationController
  before_action :user_logged_in, only: [:new,:create,:destroy,:edit, :update]
  before_action :ensure_contest_creator, only: [:new, :create, :edit, :update]
  
  def index
    @referees = Referee.all
  end
  
  def new
    @referee = current_user.referees.build
  end
  
  def create
    @referee = current_user.referees.build(acceptable_params)
    if @referee.save
      flash[:success]="Referee created"
      redirect_to @referee
    else
      flash[:danger]="Error while trying to create the referee!"
      render 'new'
    end
  end
  
  def show
    @referee = Referee.find(params[:id])  
  end
  
  def edit 
    @referee = Referee.find(params[:id])
  end
    
  def update
    @referee = Referee.find(params[:id])
    #@tempfilelocation = @referee.file_location
    if @referee.update_attributes(acceptable_params)
      flash[:success] = "Referee has been updated!"
      #if @tempfilelocation!=acceptable_params[:file_location]
        #FileUtils.rm_f(@tempfilelocation)
      #end
      redirect_to @referee
    else
      flash[:danger]="Error while trying to update the referee!"
      render 'edit'
    end
  end
  
    def destroy
      @referee = Referee.find(params[:id])
      @tempfilelocation = @referee.file_location
      if @referee.destroy
        FileUtils.rm_f(@tempfilelocation)
        flash[:success] = "Referee was destroyed."
        redirect_to referees_path
    else
        flash[:danger] = "Error while trying to delete referee!"
        redirect_to referees_path
    end 
  end 
  
  private
  
  def acceptable_params
    params.require(:referee).permit(:name, :rules_url, :players_per_game, :upload)
  end
   
  def user_logged_in
      redirect_to login_path, flash: { :warning => "Unable" } unless logged_in?
  end
  
  def ensure_contest_creator 
      redirect_to root_path, flash: { :danger => "You are not a contest creator!" } unless current_user.contest_creator?
  end
end