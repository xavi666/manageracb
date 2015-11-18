class HomeController < ApplicationController
  layout "front"

  def index
    @games = Game.where(:game_number => Setting.find_by_name(:game_number).value)
  end

  
  private
    def home_params
    end
end