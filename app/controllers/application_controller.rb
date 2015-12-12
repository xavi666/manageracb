class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :authenticated_user

  before_action :load_top_data

  add_flash_types :error, :success, :info, :warning

  private

  def init_team
    @user_team = UserTeam.new
    3.times do
      player = @user_team.bases.build
    end
    4.times do
      player = @user_team.aleros.build
    end
    4.times do
      player = @user_team.pivots.build
    end
  end

  def authenticated_user
    @authenticated_user ||= User.find_by(auth_token: cookies[:auth_token]) if cookies[:auth_token]
  end

  def require_authentication
    unless authenticated_user
      session[:intended_destination] = params
      redirect_to sign_in_path, error: 'Please sign in before continuing!'
    end
  end

  def load_top_data
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
  end

end
