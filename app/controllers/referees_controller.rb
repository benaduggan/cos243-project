class RefereesController < ApplicationController
  
  def index
    @referees = Referee.all
  end
  
  def new
    @referee = current_user.referees.build
  end
  
  def create
    @referee = current_user.referees.build(acceptable_params)
    if @referee.save
      flash[:success]="Referee created!"
      redirect_to @referee
    else
      flash[:danger]="Invalid!"
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
    if @referee.update_attributes(acceptable_params)
      flash[:success] = "Referee updated"
      redirect_to @referee
    else
      flash[:danger]="Invalid for some reason!"
      render 'edit'
    end
  end
  
    def destroy
      @referee = Referee.find(params[:id])
      if @referee.destroy
        flash[:success] = "Referee was destroyed."
        redirect_to '/referees'
    else
        flash[:danger] = "Didn't delete it yo!"
        redirect_to '/referees'
    end 
  end 
  
  private
  
  def acceptable_params
    params.require(:referee).permit(:name, :rules_url, :players_per_game, :upload)
  end
  
end