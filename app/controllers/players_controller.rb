class PlayersController < ApplicationController

  def index
    @players = Player.all
  end

  def create
    @player = Player.create(player_params)
  end

  def update
    @player.update_attributes player_params
  end

  def destroy
    @player.destroy
  end

  def show
    @player = Player.find(params[:id])
  end

  def money
    
    redirect_to action: "index"
  end

  private
    def player_params
      params.require(:player).permit([:name])
    end
end
