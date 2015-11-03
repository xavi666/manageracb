class PredictionsController < ApplicationController

  require 'rubygems'
  require 'ai4r'
  require "bundler/setup"
  Bundler.require

  include Ai4r::Classifiers
  include Ai4r::Data

  def index
    #@predictions = Prediction.all
  end

  def create
    data_labels = [ 'city', 'age_range', 'gender', 'marketing_target' ]
    data_items = [  
           ['New York',  '<30',      'M',  'Y'],
           ['Chicago',   '<30',      'M',  'Y'],
           ['Chicago',   '<30',      'F',  'Y'],
           ['New York',  '<30',      'M',  'Y'],
           ['New York',  '<30',      'M',  'Y'],
           ['Chicago',   '[30-50)',  'M',  'Y'],
           ['New York',  '[30-50)',  'F',  'N'],
           ['Chicago',   '[30-50)',  'F',  'Y'],
           ['New York',  '[30-50)',  'F',  'N'],
           ['Chicago',   '[50-80]',  'M',  'N'],
           ['New York',  '[50-80]',  'F',  'N'],
           ['New York',  '[50-80]',  'M',  'N'],
           ['Chicago',   '[50-80]',  'M',  'N'],
           ['New York',  '[50-80]',  'F',  'N'],
           ['Chicago',   '>80',      'F',  'Y']
         ]
    data_set = DataSet.new(:data_items => data_items, :data_labels => data_labels)
    id3 = Ai4r::Classifiers::ID3.new.build(data_set)   
    var = id3.eval(['New York', '<30', 'M'])
    puts var
    #redirect_to action: "index"
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