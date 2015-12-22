# population POPULATION_SIZE = 2391444
POPULATION_SIZE = 20
NUM_GENERATIONS = 50
CROSSOVER_RATE = 0.1
MUTATION_RATE = 0.00001

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
    max_price = 10000
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

      
    # problem configuration
    num_bits = 64
    # algorithm configuration
    max_gens = 100
    pop_size = 100
    p_crossover = 0.98
    p_mutation = 1.0/num_bits
    # execute the algorithm
    best = search(max_gens, num_bits, pop_size, p_crossover, p_mutation)
    @result = "done! Solution: f=#{best[:fitness]}, s=#{best[:bitstring]}"
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
        :bases => Player.active.bases.includes(predictions: :game).references(predictions: :game).where("games.season = ?", season).where("games.game_number = ?", game_number).map{ |c| [c.id, c.predictions.first.send(type), c.price_cents] },
        :aleros => Player.active.aleros.includes(predictions: :game).references(predictions: :game).where("games.season = ?", season).where("games.game_number = ?", game_number).map{ |c| [c.id, c.predictions.first.send(type), c.price_cents] },
        :pivots => Player.active.pivots.includes(predictions: :game).references(predictions: :game).where("games.season = ?", season).where("games.game_number = ?", game_number).map{ |c| [c.id, c.predictions.first.send(type), c.price_cents] }
      }
    end

    def onemax(bitstring)
      sum = 0
      bitstring.size.times {|i| sum+=1 if bitstring[i].chr=='1'}
      return sum
    end

    def random_bitstring(num_bits)
      return (0...num_bits).inject(""){|s,i| s<<((rand<0.5) ? "1" : "0")}
    end

    def binary_tournament(pop)
      i, j = rand(pop.size), rand(pop.size)
      j = rand(pop.size) while j==i
      return (pop[i][:fitness] > pop[j][:fitness]) ? pop[i] : pop[j]
    end

    def point_mutation(bitstring, rate=1.0/bitstring.size)
      child = ""
       bitstring.size.times do |i|
         bit = bitstring[i].chr
         child << ((rand()<rate) ? ((bit=='1') ? "0" : "1") : bit)
      end
      return child
    end

    def crossover(parent1, parent2, rate)
      return ""+parent1 if rand()>=rate
      point = 1 + rand(parent1.size-2)
      return parent1[0...point]+parent2[point...(parent1.size)]
    end

    def reproduce(selected, pop_size, p_cross, p_mutation)
      children = []
      selected.each_with_index do |p1, i|
        p2 = (i.modulo(2)==0) ? selected[i+1] : selected[i-1]
        p2 = selected[0] if i == selected.size-1
        child = {}
        child[:bitstring] = crossover(p1[:bitstring], p2[:bitstring], p_cross)
        child[:bitstring] = point_mutation(child[:bitstring], p_mutation)
        children << child
        break if children.size >= pop_size
      end
      return children
    end

    def search(max_gens, num_bits, pop_size, p_crossover, p_mutation)
      population = Array.new(pop_size) do |i|
        {:bitstring=>random_bitstring(num_bits)}
      end
      population.each{|c| c[:fitness] = onemax(c[:bitstring])}
      best = population.sort{|x,y| y[:fitness] <=> x[:fitness]}.first
      max_gens.times do |gen|
        selected = Array.new(pop_size){|i| binary_tournament(population)}
        children = reproduce(selected, pop_size, p_crossover, p_mutation)
        children.each{|c| c[:fitness] = onemax(c[:bitstring])}
        children.sort!{|x,y| y[:fitness] <=> x[:fitness]}
        best = children.first if children.first[:fitness] >= best[:fitness]
        population = children
        puts " > gen #{gen}, best: #{best[:fitness]}, #{best[:bitstring]}"
        break if best[:fitness] == num_bits
      end
      return best
    end

end