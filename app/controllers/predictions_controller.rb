class PredictionsController < ApplicationController
  layout "front", only: [:game]

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
    @statistics = Statistic.game.where(season: "2014").where("statistics.seconds > 0").first(10)

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

  def create_two

    ####################################
    ####### LIBLINEAR
    ####### https://github.com/kei500/liblinear-ruby
    ####################################



    # Setting parameters
    num_elements = 100
    param = Liblinear::Parameter.new
    param.solver_type = Liblinear::L2R_L2LOSS_SVR

    @statistics = Statistic.game.where(season: "2014").where("statistics.seconds > 0").first(num_elements)

    labels = @statistics.map(&:value)
    examples = []
    @statistics.each do |statistic|
      if statistic.seconds > 0
        game_number = statistic.game_number
        player_statistic = Statistic.player.where(player_id: statistic.player_id, game_number: game_number, season: "2014").first
        team_statistic = Statistic.team.where(team_id: statistic.team_against_id, game_number: game_number, season: "2014").first
        if player_statistic and team_statistic
          label = {
                0 => player_statistic.seconds / game_number, 1 => player_statistic.points / game_number, 2 => player_statistic.rebounds / game_number, 3 => player_statistic.assists / game_number, 4 => player_statistic.value / game_number,
                5 => team_statistic.points / game_number, 6 => team_statistic.rebounds / game_number, 7 => team_statistic.assists / game_number, 8 => team_statistic.rfaults / game_number, 9 => team_statistic.value / game_number }
          examples << label
        end
      end
    end

    bias = 0.5
    @labels = labels
    @examples = examples
    prob = Liblinear::Problem.new(labels, examples, bias)
    model = Liblinear::Model.new(prob, param)

    # Predicting phase
    @prediccio =  model.predict({0=>1603, 1=>6, 2=>1, 3=>2, 4=>8, 5=>90, 6=>25, 7=>12, 8=>20, 9=>97})

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

  def init
    games = Game.where(season: Setting.find_by_name(:season).value, game_number: Setting.find_by_name(:game_number).value)
    game_number = Setting.find_by_name("game_number").value.to_i
    season = Setting.find_by_name("season").value
    games.each do |game|
      puts "---->game"
      local_team_statistic = Statistic.team.where(team_id: game.local_team_id, game_number: game_number, season: season).first
      visitant_team_statistic = Statistic.team.where(team_id: game.visitant_team_id, game_number: game_number, season: season).first
      
      #jugadors equip local
      game.local_team.players.active.each do |player|
        puts "players local"
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
        puts "player visitant"
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

end