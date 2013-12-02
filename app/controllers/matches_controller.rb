class MatchesController < ApplicationController

  def index
    contest = Contest.find(params[:contest_id])
    @matches=Match.all
    @contestmatches=Match.find_by_manager_id(params[:contest_id])
  end
  
  def show
    @match=Match.find(params[:id])
  end
end
