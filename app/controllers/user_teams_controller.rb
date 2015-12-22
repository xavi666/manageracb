#http://www.cleveralgorithms.com/nature-inspired/evolution/genetic_algorithm.html

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
    
    # algorithm configuration
    max_gens = 200
    pop_size = 100
    p_crossover = 0.98
    p_mutation = 1.0/11
    # execute the algorithm
    @best = search(max_gens, pop_size, p_crossover, p_mutation, all_players)
    @result = "done! Solution: f=#{@best[:fitness]}, s=#{@best[:players]}"
    puts @result
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
        :bases => Player.active.bases.includes(predictions: :game).references(predictions: :game).where("games.season = ?", season).where("games.game_number = ?", game_number).map{ |c| {id: c.id, value: c.predictions.first.send(type), price: c.price_cents} },
        :aleros => Player.active.aleros.includes(predictions: :game).references(predictions: :game).where("games.season = ?", season).where("games.game_number = ?", game_number).map{ |c| {id: c.id, value: c.predictions.first.send(type), price: c.price_cents} },
        :pivots => Player.active.pivots.includes(predictions: :game).references(predictions: :game).where("games.season = ?", season).where("games.game_number = ?", game_number).map{ |c| {id: c.id, value: c.predictions.first.send(type), price: c.price_cents} }
      }
    end

    def onemax(players)
      price = 0
      value = 0
      players.each do |player|
        price += player[:price]
        value += player[:value]
      end
      return value
    end

    def binary_tournament(pop)
      i, j = rand(pop.size), rand(pop.size)
      j = rand(pop.size) while j==i
      return (pop[i][:fitness] > pop[j][:fitness]) ? pop[i] : pop[j]
    end

    def point_mutation(players, rate=1.0/players.size, all_players)
      child = Array.new
      players.size.times do |i|
        player = players[i]
        if rand()<rate
          case i
            when 0..2
              player = all_players[:bases][rand(0..all_players[:bases].count-1)]
            when 3..6 
              player = all_players[:aleros][rand(0..all_players[:aleros].count-1)]
            else
              player = all_players[:pivots][rand(0..all_players[:pivots].count-1)]
            end 
        end
        child[i] = player  
      end
      return child
    end

    def crossover(parent1, parent2, rate)
      return parent1 
      #if rand()>=rate
      point = 1 + rand(parent1.size-2)
      return parent1[0...point]+parent2[point...(parent1.size)]
    end

    def reproduce(selected, pop_size, p_cross, p_mutation, all_players)
      children = []
      selected.each_with_index do |p1, i|
        p2 = (i.modulo(2)==0) ? selected[i+1] : selected[i-1]
        p2 = selected[0] if i == selected.size-1
        child = {}
        child[:players] = crossover(p1[:players], p2[:players], p_cross)
        child[:players] = point_mutation(child[:players], p_mutation, all_players)
        children << child
        break if children.size >= pop_size
      end
      return children
    end

    def search(max_gens, pop_size, p_crossover, p_mutation, all_players)
      population = Array.new(pop_size) do |i|
        bases = 3.times.map{ all_players[:bases][rand(0..all_players[:bases].count-1)] } 
        aleros = 4.times.map{ all_players[:aleros][rand(0..all_players[:aleros].count-1)] } 
        pivots = 4.times.map{ all_players[:pivots][rand(0..all_players[:pivots].count-1)] } 
        players = bases + aleros + pivots
        {:players=>players}
      end
      population.each{|c| c[:fitness] = onemax(c[:players])}
      best = population.sort{|x,y| y[:fitness] <=> x[:fitness]}.first
      max_gens.times do |gen|
        selected = Array.new(pop_size){|i| binary_tournament(population)}
        children = reproduce(selected, pop_size, p_crossover, p_mutation, all_players)
        children.each{|c| c[:fitness] = onemax(c[:players])}
        children.sort!{|x,y| y[:fitness] <=> x[:fitness]}
        best = children.first if children.first[:fitness] >= best[:fitness]
        population = children
        puts " > gen #{gen}, best: #{best[:fitness]}, #{best[:players]}"
      end
      return best
    end

end