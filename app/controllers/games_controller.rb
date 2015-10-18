class GamesController < ApplicationController

  def index
    @games = Team.all
  end

  def create
    @game = Team.create(team_games)
  end

  def update
    @game.update_attributes game_params
  end

  def destroy
    @game.destroy
  end

  private
    def game_params
      params.require(:game).permit([:name])
    end
end