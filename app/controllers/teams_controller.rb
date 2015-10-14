class ProjectMachinesController < ApplicationController

  def index
    @teams = Team.all
  end

  def create
    @team = Team.create(team_params)
  end

  def update
    @team.update_attributes team_params
  end

  def destroy
    @team.destroy
  end

  private
    def team_params
      params.require(:team).permit([:name])
    end
end