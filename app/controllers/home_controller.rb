class HomeController < ApplicationController

  include SortableFilterHelper
  layout "front"

  def index
    @games = Game.find_game_number(Setting.find_by_name(:game_number).value).find_season(Setting.find_by_name(:season).value)
  end

  
  private
    def home_params
    end
end