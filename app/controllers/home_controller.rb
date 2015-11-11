class HomeController < ApplicationController
  layout "front"

  def index
    @games = Game.where(:game_number => 6)
  end

  
  private
    def home_params
    end
end