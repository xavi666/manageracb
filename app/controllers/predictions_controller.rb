class PredictionsController < ApplicationController

  require 'rubygems'
  require 'ai4r'

  def index
    #@predictions = Prediction.all
  end

  def create
    DATA_LABELS = [ 'city', 'age_range', 'gender', 'marketing_target' ]

    #@predictions = Prediction.create(prediction_params)
    redirect_to action: "index"
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