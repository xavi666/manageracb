class PredictionsController < ApplicationController
  layout "front", only: [:game]
  include SortableFilterHelper
  
  require 'rubygems'
  #require 'ai4r'
  require "bundler/setup"
  #include Ai4r::Classifiers
  #include Ai4r::Data
  

  def index
    #@predictions = Prediction.all
  end

  def create

    ####################################
    ####### LIBSVM
    ####### https://github.com/febeling/rb-libsvm
    ####################################

    # This library is namespaced.
    problem = Libsvm::Problem.new
    parameter = Libsvm::SvmParameter.new

    parameter.cache_size = 1 # in megabytes

    parameter.eps = 0.001
    parameter.c = 10

    examples = [ [1,0,1], [-1,0,-1] ].map {|ary| Libsvm::Node.features(ary) }
    labels = [1, -1]

    problem.set_examples(labels, examples)

    model = Libsvm::Model.train(problem, parameter)

    pred = model.predict(Libsvm::Node.features(1, 1, 1))
    puts "Example [1, 1, 1] - Predicted #{pred}"

    #######
    # This library is namespaced.
    problem = Libsvm::Problem.new
    parameter = Libsvm::SvmParameter.new

    parameter.cache_size = 1 # in megabytes

    parameter.eps = 0.001
    parameter.c = 1


    values = %w(seconds points value game_number)
    labels = %w(value)
    @statistics = Statistic.game.find_season("2014").where("statistics.seconds > 0").first(1000)

    @training_values = []
    @statistics.each do |statistic|
      if statistic.seconds > 0
        game_number = statistic.game_number
        player_statistic = Statistic.player.where(player_id: statistic.player_id, game_number: game_number, season: "2014").first
        team_statistic = Statistic.team.where(team_id: statistic.team_against_id, game_number: game_number, season: "2014").first
        if player_statistic and team_statistic
          @training_values << [player_statistic.seconds / game_number, player_statistic.points / game_number, player_statistic.rebounds / game_number, player_statistic.assists / game_number, player_statistic.value / game_number,
                team_statistic.points / game_number, team_statistic.rebounds / game_number, team_statistic.assists / game_number, team_statistic.rfaults / game_number, team_statistic.value / game_number ]
        end
      end
    end

    @training_labels = @statistics.map(&:value)

    examples = @training_values.map {|ary| Libsvm::Node.features(ary) }
    labels = @training_labels
    problem.set_examples(labels, examples)
    model = Libsvm::Model.train(problem, parameter)
    @pred = model.predict(Libsvm::Node.features(1822, 18, 9, 1, 20, 76, 27, 10, 20, 65))
    puts "Example [1822, 18, 9, 1, 20, 76, 27, 10, 20, 65] - Predicted #{pred}"

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

      # Setting parameters
      param = Liblinear::Parameter.new
      #param.solver_type = Liblinear::L2R_L2LOSS_SVR
      #param.solver_type = Liblinear::L2R_L2LOSS_SVR_DUAL
      param.solver_type = Liblinear::L2R_L1LOSS_SVR_DUAL

      @statistics = Statistic.game.find_season("2014").where("statistics.seconds > 0").first(num_elements)

      labels = labels(@statistics, type) 
      test = []
      @statistics.each do |statistic|
        if statistic.seconds > 0
          test << values(statistic, statistic.game_number, "2014", type)
        end
      end

      bias = 0.5
      @labels = labels
      @test = test
      prob = Liblinear::Problem.new(labels, test, bias)
      model = Liblinear::Model.new(prob, param)

      prediccions = Prediction.where("games.season = ?", season).where("games.game_number = ?",game_number.to_i).includes(:game)
      prediccions.each do |prediccio|
        player_statistic = Statistic.player.where(player_id: prediccio.player_id, game_number: game_number, season: season).first
        team_statistic = Statistic.team.where(team_id: prediccio.team_id, game_number: game_number, season: season).first
        if player_statistic and team_statistic
          prediccio_values = values(prediccio, game_number, season, type)
          # Predicting phase
          prediccio_label =  model.predict(prediccio_values)
          prediccio = update_field_prediction(prediccio, prediccio_label, type)
          prediccio.save!
        end
      end
      # Analyzing phase
      @coefficient = model.coefficient
      @bias =  model.bias

      # Cross Validation
      fold = 2
      cv = Liblinear::CrossValidator.new(prob, param, fold)
      cv.execute

      # for regression
      @mean_squared_error = cv.mean_squared_error
      # for regression
      @squared_correlation_coefficient = cv.squared_correlation_coefficient
    end
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

  def update
    @prediction.update_attributes predictium_params
  end

  def show
    @prediction = Prediction.find(params[:id])
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
      case statistic_prediction.class.name
      when "Prediction"
        team_statistic = Statistic.team.where(team_id: statistic_prediction.team_id, game_number: game_number, season: season).first
      when "Statistic"
        team_statistic = Statistic.team.where(team_id: statistic_prediction.team_against_id, game_number: game_number, season: season).first
      else
        team_statistic = Statistic.team.where(team_id: statistic_prediction.team_id, game_number: game_number, season: season).first
      end
      player_statistic = Statistic.player.where(player_id: statistic_prediction.player_id, game_number: game_number, season: season).first
      
      if player_statistic and team_statistic
        case type
        when "value"
          label = {
              0 => player_statistic.value / game_number,
              1 => team_statistic.value / game_number }
        when "points"
          label = {
              0 => player_statistic.points / game_number,
              1 => team_statistic.points / game_number }
        when "assists"
          label = {
              0 => player_statistic.assists / game_number,
              1 => team_statistic.assists / game_number }
        when "rebounds"
          label = {
              0 => player_statistic.rebounds / game_number,
              1 => team_statistic.rebounds / game_number }
        when "three_pm"
          label = {
              0 => player_statistic.three_pm / game_number,
              1 => team_statistic.three_pm / game_number }
        else
           label = {
              0 => player_statistic.value / game_number,
              1 => team_statistic.value / game_number }
        end 
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
end