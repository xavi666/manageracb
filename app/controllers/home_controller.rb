class HomeController < ApplicationController

  include SortableFilterHelper
  layout "front"

  def index
    @games = Game.find_game_number(Setting.find_by_name(:game_number).value).find_season(Setting.find_by_name(:season).value)
    @top_ten =  {
                  values: {
                            bases: Prediction.joins(:player).merge(Player.bases).top_ten_value,
                            aleros: Prediction.joins(:player).merge(Player.aleros).top_ten_value,
                            pivots: Prediction.joins(:player).merge(Player.pivots).top_ten_value
                          },                          
                  points: {
                            bases: Prediction.joins(:player).merge(Player.bases).top_ten_points,
                            aleros: Prediction.joins(:player).merge(Player.aleros).top_ten_points,
                            pivots: Prediction.joins(:player).merge(Player.pivots).top_ten_points
                          }
                }
              #joins(:books).merge(Book.available)
    authenticated_user
    init_team
  end
  
  private
    def home_params
    end
end