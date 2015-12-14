class PredictionsController < ApplicationController
  layout "front", only: [:game, :show]
  include SortableFilterHelper
  include EnumerableHelper
  require 'rubygems'
  require "bundler/setup"

  def index
    #@predictions = Prediction.all
  end

  def init
    games = Game.where(season: Setting.find_by_name(:season).value, game_number: Setting.find_by_name(:game_number).value)
    game_number = Setting.find_by_name("game_number").value.to_i
    season = Setting.find_by_name("season").value
    games.each do |game|
      local_team_statistic = Statistic.team.where(team_id: game.local_team_id, game_number: game_number, season: season).first
      visitant_team_statistic = Statistic.team.where(team_id: game.visitant_team_id, game_number: game_number, season: season).first
      
      #jugadors equip local
      game.local_team.players.active.each do |player|
        #I need to check the player is active
        player_statistic = Statistic.player.where(player_id: player.id, game_number: game_number, season: season).first
        if player_statistic and visitant_team_statistic
          prediction = Prediction.where(player_id: player_statistic.player_id, team_id: visitant_team_statistic.team_id, game_id: game.id).first
          unless prediction
            prediction = Prediction.create!(player_id: player_statistic.player_id, team_id: visitant_team_statistic.team_id, game_id: game.id)
          end
        end
      end

      #jugadors equip visitant
      game.visitant_team.players.active.each do |player|
        player_statistic = Statistic.player.where(player_id: player.id, game_number: game_number, season: season).first
        if player_statistic and local_team_statistic
          prediction = Prediction.where(player_id: player_statistic.player_id, team_id: local_team_statistic.team_id, game_id: game.id).first
          unless prediction
            prediction = Prediction.create!(player_id: player_statistic.player_id, team_id: local_team_statistic.team_id, game_id: game.id)
          end
        end
      end
    end
  end

  def predict
    if params[:search]
      ####################################
      ####### LIBLINEAR
      ####### https://github.com/kei500/liblinear-ruby
      ####################################

      #params
      num_elements = params[:search][:num_elements].to_i
      season = params[:search][:season]
      game_number = params[:search][:num_games].to_i
      type = params[:search][:type]
      season_data = Setting.find_by_name("season_data").value

      # Setting parameters
      param = Liblinear::Parameter.new
      #param.solver_type = Liblinear::L2R_L2LOSS_SVR
      param.solver_type = Liblinear::L2R_L2LOSS_SVR_DUAL
      #param.solver_type = Liblinear::L2R_L1LOSS_SVR_DUAL

      @statistics = Statistic.game.find_season(season_data).where("statistics.seconds > 0")
      @statistics = @statistics.shuffle.first(num_elements)

      labels = labels(@statistics, type) 
      test = []
      @statistics.each do |statistic|
        if statistic.seconds > 0
          test << values(statistic, statistic.game_number, season_data, type)
        end
      end

      test = normalize test

      bias = 0.5
      @labels = labels
      @test = test
      prob = Liblinear::Problem.new(labels, test, bias)
      model = Liblinear::Model.new(prob, param)

      #prediccions = Prediction.where("games.season = ?", season).where("games.game_number = ?",game_number.to_i).includes(:game)
      #prediccions.each do |prediccio|
      #  player_statistic = Statistic.player.where(player_id: prediccio.player_id, game_number: game_number, season: season).first
      #  team_statistic = Statistic.team.where(team_id: prediccio.team_id, game_number: game_number, season: season).first
      #  if player_statistic and team_statistic
      #    prediccio_values = values(prediccio, game_number, season, type)
          # Predicting phase
      #    prediccio_label = model.predict(prediccio_values)
      #    prediccio = update_field_prediction(prediccio, prediccio_label, type)
      #    prediccio.save!
      #  end
      #end
      # Analyzing phase
      #@coefficient = model.coefficient
      #@bias =  model.bias
      # Cross Validation  
      #fold = 2
      #cv = Liblinear::CrossValidator.new(prob, param, fold)
      #cv.execute

      # for regression
      #@mean_squared_error = cv.mean_squared_error
      # for regression
      #@squared_correlation_coefficient = cv.squared_correlation_coefficient
    end
  end

  def update
    @prediction.update_attributes predictium_params
  end

  def show
    @game = Game.find(params[:id])
    @predictions = Prediction.where(game_id: params[:id])
  end

  def destroy
    @prediction.destroy
  end

  private
    def prediction_params
      params.require(:prediction).permit()
    end

    def labels  statistics, type
      case type
      when "value"
        labels = statistics.map(&:value)
      when "points"
        labels = statistics.map(&:points)
      when "assists"
        labels = statistics.map(&:assists)
      when "rebounds"
        labels = statistics.map(&:rebounds)
      when "three_pm"
        labels = statistics.map(&:three_pm)
      else
        labels = statistics.map(&:value)
      end 
      labels 
    end

    def values statistic_prediction, game_number, season, type 
      team_statistic = Statistic.team.where(team_id: statistic_prediction.player.team_id, game_number: game_number, season: season).first
      team_against_statistic = Statistic.team.where(team_id: statistic_prediction.team_id, game_number: game_number, season: season).first
      player_statistic = Statistic.player.where(player_id: statistic_prediction.player_id, game_number: game_number, season: season).first
      
      if player_statistic and team_statistic
        case type
        when "value"
          label = {
              0 => player_statistic.value / game_number,
              1 => team_statistic.value / game_number,
              2 => team_against_statistic.value_received / game_number }
        when "points"
          label = {
              0 => player_statistic.points / game_number,
              1 => team_statistic.points / game_number,
              2 => team_against_statistic.value_received / game_number }
        when "assists"
          label = {
              0 => player_statistic.assists / game_number,
              1 => team_statistic.assists / game_number,
              2 => team_against_statistic.value_received / game_number }
        when "rebounds"
          label = {
              0 => player_statistic.rebounds / game_number,
              1 => team_statistic.rebounds / game_number,
              2 => team_against_statistic.value_received / game_number }
        when "three_pm"
          label = {
              0 => player_statistic.three_pm / game_number,
              1 => team_statistic.three_pm / game_number,
              2 => team_against_statistic.value_received / game_number }
        else
          label = {
              0 => player_statistic.value / game_number,
              1 => team_statistic.value / game_number,
              2 => team_against_statistic.value_received / game_number }
        end 
        label[3] = player_statistic.player.position_integer
      end
      label
    end

    def update_field_prediction prediction, prediccio_label, type
      case type
      when "value"
        prediction.value = prediccio_label
      when "points"
        prediction.points = prediccio_label
      when "assists"
        prediction.assists = prediccio_label
      when "rebounds"
        prediction.rebounds = prediccio_label
      when "three_pm"
        prediction.three_pm = prediccio_label
      else
        prediction.value = prediccio_label
      end 
      prediction  
    end

    def normalize test
      puts "---------> TEST"
      fields = ["player_statistic", "team_statistic", "team_against_statistic", "player_position"]
      normalized = {}
      fields.each do |field|
        normalized[field] = {
                        "values" => Array.new,
                        "sum" => 0,
                        "mean" => 0,
                        "sample_variance" => 0,
                        "standard_deviation" => 0
                      }
      end
      
      test.each do |row|
        normalized["player_statistic"]["values"] << row[0]
        normalized["team_statistic"]["values"] << row[1]
        normalized["team_against_statistic"]["values"] << row[2]
        normalized["player_position"]["values"] << row[3]
      end

      fields.each do |field|
        normalized[field]["sum"] = sum(normalized[field]["values"])
        normalized[field]["mean"] = mean(normalized[field]["values"])
        normalized[field]["sample_variance"] = sample_variance(normalized[field]["values"])
        normalized[field]["standard_deviation"] = standard_deviation(normalized[field]["values"])
      end

      test
    end

    def sum(a)
      a.inject(0){ |accum, i| accum + i }
    end

    def mean(a)
      sum(a) / a.length.to_f
    end

    def sample_variance(a)
      m = mean(a)
      sum = a.inject(0){ |accum, i| accum + (i - m) ** 2 }
      sum / (a.length - 1).to_f
    end

    def standard_deviation(a)
      Math.sqrt(sample_variance(a))
    end
end