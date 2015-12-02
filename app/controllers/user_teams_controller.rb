POPULATION_SIZE = 300
NUM_BITS = 64
NUM_GENERATIONS = 1
CROSSOVER_RATE = 0.4
MUTATION_RATE = 0.000001

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
    puts "------------> OPTIMIZE"
    @user_team = UserTeam.new(user_team_params)
    players_ids = []
    players = Hash.new {|h,k| h[k]=[]}

    user_team_params[:bases_attributes].each do |player|
      players_ids << player[1][:player_id]
      players[:bases] << player[1][:player_id]
    end
    user_team_params[:aleros_attributes].each do |player|
      players_ids << player[1][:player_id]
      players[:aleros] << player[1][:player_id]
    end
    user_team_params[:pivots_attributes].each do |player|
      players_ids << player[1][:player_id]
      players[:pivots] << player[1][:player_id]
    end

    season = Setting.find_by_name(:season).value
    game_number = Setting.find_by_name(:game_number).value.to_i
    all_players = {
                  :bases => Player.active.bases.includes(predictions: :game).where("games.season = ?", season).where("games.game_number = ?", game_number).map{ |c| [c.id, c.predictions.first.value] },
                  :aleros => Player.active.aleros.includes(predictions: :game).where("games.season = ?", season).where("games.game_number = ?", game_number).map{ |c| [c.id, c.predictions.first.value] },
                  :pivots => Player.active.pivots.includes(predictions: :game).where("games.season = ?", season).where("games.game_number = ?", game_number).map{ |c| [c.id, c.predictions.first.value] }
                }

    population = players
    population = Population.new
    population.seed! all_players

    1.upto(NUM_GENERATIONS).each do |generation|
      offspring = Population.new      
      while offspring.count < population.count
        parent1 = population.select
        parent2 = population.select

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

      @result = "Generation #{generation} - Average: #{population.average_fitness.round(2)} - Max: #{population.max_fitness}"

      population = offspring
    end

    @population = population
    puts "Final population: " + @population.inspect
    ap population
  end

  def new
  end

  private
    def user_team_params
      params.require(:user_team).permit(:name, {bases_attributes: [:player_id]}, {aleros_attributes: [:player_id]}, {pivots_attributes: [:player_id]} )
    end

    def player_ids

    end
end