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

    ####################################
    ####### LIBLINEAR
    ####### https://github.com/kei500/liblinear-ruby
    ####################################

    # Setting parameters
    param = Liblinear::Parameter.new
    param.solver_type = Liblinear::L2R_LR

    # Training phase
    labels = [1, -1]
    examples = [
      {1=>0, 2=>0, 3=>0, 4=>0, 5=>0},
      {1=>1, 2=>1, 3=>1, 4=>1, 5=>1}
    ]
    bias = 0.5
    prob = Liblinear::Problem.new(labels, examples, bias)
    model = Liblinear::Model.new(prob, param)

    # Predicting phase
    puts model.predict({1=>1, 2=>1, 3=>1, 4=>1, 5=>1}) # => -1.0

    # Analyzing phase
    puts model.coefficient
    puts model.bias

    # Cross Validation
    fold = 2
    cv = Liblinear::CrossValidator.new(prob, param, fold)
    cv.execute

    puts cv.accuracy                        # for classification
    puts cv.mean_squared_error              # for regression
    puts cv.squared_correlation_coefficient # for regression



    #######
    # This library is namespaced.
    problem = Libsvm::Problem.new
    parameter = Libsvm::SvmParameter.new

    parameter.cache_size = 1 # in megabytes

    parameter.eps = 0.001
    parameter.c = 10


    values = %w(seconds points value game_number)
    labels = %w(value)
    @statistics = Statistic.game.where(season: "2014").where("statistics.seconds > 0").select(values)

    @training_values = @statistics.map {|e| [e.seconds / e.game_number, e.points / e.game_number]} 
    @training_labels = @statistics.map(&:value)

    examples = @training_values.map {|ary| Libsvm::Node.features(ary) }
    labels = @training_labels

    problem.set_examples(labels, examples)

    model = Libsvm::Model.train(problem, parameter)

    @pred = model.predict(Libsvm::Node.features(1200, 1))
    puts "Example [1000, 10] - Predicted #{pred}"

  end

  def game
    @predictions = Prediction.where(:game => params[:id])
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