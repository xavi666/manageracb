class HomeController < ApplicationController

  include SortableFilterHelper
  layout "front"

  def index
    @games = Game.find_game_number(Setting.find_by_name(:game_number).value).find_season(Setting.find_by_name(:season).value)
    load_top_data
    authenticated_user
    init_team
  end
  
  private
    def home_params
    end
end