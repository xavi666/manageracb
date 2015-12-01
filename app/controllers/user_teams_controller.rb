class UserTeamsController < ApplicationController

  def index
    @user_teams = UserTeam.all
  end

  def create
    @user_team = UserTeam.create(user_team_params)
  end

  def update
    @user_team.update_attributes user_team_params
  end

  def show
    @user_team = UserTeam.find(params[:id])
  end

  def destroy
    @user_team.destroy
  end

  def optimize
    puts "------------> OPTIMIZE"
    @user_team = UserTeam.new(user_team_params)
    players= []
    user_team_params[:bases_attributes].each do |player|
      players << player[1][:player_id]
    end
    user_team_params[:aleros_attributes].each do |player|
      players << player[1][:player_id]
    end
    user_team_params[:pivots_attributes].each do |player|
      players << player[1][:player_id]
    end
    population = players
    puts "++++++++++"
    puts "POPULATION"
    puts population.inspect
    ap population
  end

  def new
  end

  private
    def user_team_params
      params.require(:user_team).permit(:name, {bases_attributes: [:player_id]}, {aleros_attributes: [:player_id]}, {pivots_attributes: [:player_id]} )
    end

    def player_ids

    end
end