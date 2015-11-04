class PredictionsController < ApplicationController

  require 'rubygems'
  require 'ai4r'
  require "bundler/setup"
  include Ai4r::Classifiers
  include Ai4r::Data

  def index
    #@predictions = Prediction.all
  end

  def create
    data_labels = %w(seconds points two_p two_pm value)
    #data_items = [  
    #       ['New York',  '<30',      'M',  'Y'],
    #       ['Chicago',   '<30',      'M',  'Y'],
    #       ['Chicago',   '<30',      'F',  'Y'],
    #       ['New York',  '<30',      'M',  'Y'],
    #       ['New York',  '<30',      'M',  'Y'],
    #       ['Chicago',   '[30-50)',  'M',  'Y'],
    #       ['New York',  '[30-50)',  'F',  'N'],
    #       ['Chicago',   '[30-50)',  'F',  'Y'],
    #       ['New York',  '[30-50)',  'F',  'N'],
    #       ['Chicago',   '[50-80]',  'M',  'N'],
    #       ['New York',  '[50-80]',  'F',  'N'],
    #       ['New York',  '[50-80]',  'M',  'N'],
    #       ['Chicago',   '[50-80]',  'M',  'N'],
    #       ['New York',  '[50-80]',  'F',  'N'],
    #       ['Chicago',   '>80',      'F',  'Y']
    #     ]
    data_set = DataSet.new(:data_labels => data_labels, :data_items => Statistic.player.pluck(*data_labels))

    test = [1500, 10, 6, 4]

    #id3 = Ai4r::Classifiers::ID3.new.build(data_set)   
    #prism = Ai4r::Classifiers::Prism.new.build(data_set)   
    b = NaiveBayes.new
          .set_parameters(m: 0)
          .build(data_set)

    #@prediction = id3.eval([300, 10, 6, 4])
    #@prediction = prism.eval(test)
    #@rules = id3.get_rules
    b.eval(test)
    @prediction = b.get_probability_map(test)
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