class UserTeamPlayersController < ApplicationController

  def index
    @user_team_players = UserTeamPlayer.all
  end

  def create
    @user_team_player = UserTeamPlayer.create(user_team_players_params)
  end

  def update
    @user_team_player.update_attributes user_team_players_params
  end

  def show
    @user_team_player = UserTeamPlayer.find(params[:id])
  end

  def destroy
    @user_team_player.destroy
  end

  def new
  end

  private
    def user_team_players_params
      params.require(:user_team_players).permit([:name])
    end
end