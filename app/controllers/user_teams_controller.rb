# population POPULATION_SIZE = 2391444
POPULATION_SIZE = 200
NUM_GENERATIONS = 10
CROSSOVER_RATE = 0.4
MUTATION_RATE = 0.1

# http://mattmazur.com/2013/08/18/a-simple-genetic-algorithm-written-in-ruby/
# http://gems.sciruby.com/


class UserTeamsController < ApplicationController

  def index
    @user_teams = UserTeam.all
  end

  def create
    @user_team = UserTeam.create(user_team_params)
  end

  def update
    @user_team.update_attributes user_team_params
  end

  def show
    @user_team = UserTeam.find(params[:id])
  end

  def destroy
    @user_team.destroy
  end

  def optimize
    type = "value" if params["value"] 
    type = "points" if params["points"] 
    type = "rebounds" if params["rebounds"] 
    type = "assists" if params["assists"] 
    type = "rebounds" if params["rebounds"] 
    type = "three_pm" if params["three_pm"] 

    @user_team = UserTeam.new(user_team_params)
    players_ids = []
    players = Hash.new {|h,k| h[k]=[]}

    if user_team_params[:bases_attributes]
      user_team_params[:bases_attributes].each do |player|
        players_ids << player[1][:player_id]
        players[:bases] << player[1][:player_id]
      end
    end
    if user_team_params[:aleros_attributes]
      user_team_params[:aleros_attributes].each do |player|
        players_ids << player[1][:player_id]
        players[:aleros] << player[1][:player_id]
      end
    end
    if user_team_params[:pivots_attributes]
      user_team_params[:pivots_attributes].each do |player|
        players_ids << player[1][:player_id]
        players[:pivots] << player[1][:player_id]
      end
    end

    season = Setting.find_by_name(:season).value
    game_number = Setting.find_by_name(:game_number).value.to_i
    
    all_players = get_all_players type, season, game_number

    @population = players
    @population = Population.new
    @population.seed! all_players

    1.upto(NUM_GENERATIONS).each do |generation|
      offspring = Population.new      
      while offspring.count < @population.count
        parent1 = @population.select
        parent2 = @population.select

        if rand <= CROSSOVER_RATE
          child1, child2 = parent1 & parent2
        else
          child1 = parent1
          child2 = parent2
        end

        child1.mutate! all_players
        child2.mutate! all_players
        
        if POPULATION_SIZE.even?
          offspring.chromosomes << child1 << child2
        else
          offspring.chromosomes << [child1, child2].sample
        end
      end

      @population = offspring
      @result = "Generation #{generation} - Average: #{@population.average_fitness.round(2)} - Max: #{@population.max_fitness} - Values: #{@population.max_fitness_ids}"
    end
  end

  def new
  end

  private
    def user_team_params
      params.require(:user_team).permit(:name, {bases_attributes: [:player_id]}, {aleros_attributes: [:player_id]}, {pivots_attributes: [:player_id]} )
    end

    def get_all_players type, season, game_number
      type ||= "value"
      {
        :bases => Player.active.bases.includes(predictions: :game).references(predictions: :game).where("games.season = ?", season).where("games.game_number = ?", game_number).map{ |c| [c.id, c.predictions.first.send(type)] },
        :aleros => Player.active.aleros.includes(predictions: :game).references(predictions: :game).where("games.season = ?", season).where("games.game_number = ?", game_number).map{ |c| [c.id, c.predictions.first.send(type)] },
        :pivots => Player.active.pivots.includes(predictions: :game).references(predictions: :game).where("games.season = ?", season).where("games.game_number = ?", game_number).map{ |c| [c.id, c.predictions.first.send(type)] }
      }
    end
end