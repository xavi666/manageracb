class StatisticsController < ApplicationController

  def index
    @statistics = Statistic.all
  end

  def create
    @statistic = Statistic.create(statistic_params)
  end

  def update
    @statistic.update_attributes statistic_params
  end

  def destroy
    @statistic.destroy
  end

  private
    def statistic_params
      params.require(:statistic).permit([:name])
    end

end