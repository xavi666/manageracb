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
    max_price = 10000000
    type = "value" if params["value"] 
    type = "points" if params["points"] 
    type = "rebounds" if params["rebounds"] 
    type = "assists" if params["assists"] 
    type = "rebounds" if params["rebounds"] 
    type = "three_pm" if params["three_pm"] 

    @user_team = UserTeam.new(user_team_params)
    season = Setting.find_by_name(:season).value
    game_number = Setting.find_by_name(:game_number).value.to_i

    all_players = get_all_players type, season, game_number
    
    # settings configuration
    num_players = 11
    # algorithm configuration
    max_gens = 40
    pop_size = 100
    p_crossover = 0.98
    p_mutation = 1.0/num_players
    # execute the algorithm
    max_price = user_team_params[:max_price_cents].to_i
    max_price = 20000000 if max_price == 0
    @best = search(max_gens, pop_size, p_crossover, p_mutation, all_players, num_players, max_price)
    @result = "done! Solution: f=#{@best[:fitness]}, s=#{@best[:players]}, price=#{@best[:players].map {|p| p[:price]}.reduce(0, :+)}"
    puts @result
  end

  def new
  end

  private
    def user_team_params
      params.require(:user_team).permit(:name, :max_price_cents,  {bases_attributes: [:player_id]}, {aleros_attributes: [:player_id]}, {pivots_attributes: [:player_id]} )
    end

    def get_all_players type, season, game_number
      type ||= "value"
      {
        :bases => Player.active.bases.includes(predictions: :game).references(predictions: :game).where("games.season = ?", season).where("games.game_number = ?", game_number).map{ |c| {id: c.id, value: c.predictions.first.send(type), price: c.price_cents/100} },
        :aleros => Player.active.aleros.includes(predictions: :game).references(predictions: :game).where("games.season = ?", season).where("games.game_number = ?", game_number).map{ |c| {id: c.id, value: c.predictions.first.send(type), price: c.price_cents/100} },
        :pivots => Player.active.pivots.includes(predictions: :game).references(predictions: :game).where("games.season = ?", season).where("games.game_number = ?", game_number).map{ |c| {id: c.id, value: c.predictions.first.send(type), price: c.price_cents/100} }
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

    def tournament(pop)
      i, j = rand(pop.size), rand(pop.size)
      j = rand(pop.size) while j==i
      return (pop[i][:fitness] > pop[j][:fitness]) ? pop[i] : pop[j]
    end

    def point_mutation(players, rate=1.0/players.size, all_players, max_price)
      child = Array.new
      players.size.times do |i|
        player = players[i]
        if rand() < rate
          price = players.map {|p| p[:price]}.reduce(0, :+)
          while players.include?(player) and price > max_price
            case i
              when 0..2
                player = all_players[:bases][rand(0..all_players[:bases].count-1)]
              when 3..6 
                player = all_players[:aleros][rand(0..all_players[:aleros].count-1)]
              else
                player = all_players[:pivots][rand(0..all_players[:pivots].count-1)]
              end 
          end
        end
        child[i] = player  
      end
      return child
    end

    def crossover(parent1, parent2, rate, max_price)
      return parent1 if rand()>=rate
      point = 1 + rand(parent1.size-2)
      new_parent = parent1[0...point]+parent2[point...(parent1.size)]
      price = new_parent.map {|p| p[:price]}.reduce(0, :+)
      puts "price --->"
      puts price
      while new_parent.uniq.length != new_parent.length and price > max_price do
        point = 1 + rand(parent1.size-2)
        new_parent = parent1[0...point]+parent2[point...(parent1.size)]
        price = new_parent.map {|p| p[:price]}.reduce(0, :+)
        puts "iiin price"
        puts price
      end
      return new_parent
    end

    def reproduce(selected, pop_size, p_cross, p_mutation, all_players, max_price)
      children = []
      selected.each_with_index do |p1, i|
        p2 = (i.modulo(2)==0) ? selected[i+1] : selected[i-1]
        p2 = selected[0] if i == selected.size-1
        child = {}
        child[:players] = crossover(p1[:players], p2[:players], p_cross, max_price)
        child[:players] = point_mutation(child[:players], p_mutation, all_players, max_price)
        children << child
        break if children.size >= pop_size
      end
      return children
    end

    def search(max_gens, pop_size, p_crossover, p_mutation, all_players, num_players, max_price)
      population = Array.new(pop_size) do |i|
        players = Array.new
        i = 0
        price = 0
        while players.size < num_players do
          case i
            when 0..2
              player = all_players[:bases][rand(0..all_players[:bases].count-1)]
            when 3..6 
              player = all_players[:aleros][rand(0..all_players[:aleros].count-1)]
            else
              player = all_players[:pivots][rand(0..all_players[:pivots].count-1)]
            end 
            unless players.include?(player) and player[:price] + price < max_price
              price += player[:price]
              players[i] = player
              i += 1
            else
              i -= 1
              players.pop
            end
          break if players.size >= num_players
        end

        {:players=>players}
      end
      population.each{|c| c[:fitness] = onemax(c[:players])}
      best = population.sort{|x,y| y[:fitness] <=> x[:fitness]}.first

      max_gens.times do |gen|
        selected = Array.new(pop_size){|i| tournament(population)}
        children = reproduce(selected, pop_size, p_crossover, p_mutation, all_players, max_price)
        children.each{|c| c[:fitness] = onemax(c[:players])}
        children.sort!{|x,y| y[:fitness] <=> x[:fitness]}        
        best = children.first if children.first[:fitness] >= best[:fitness]
        population = children
        puts " > gen #{gen}, best: #{best[:fitness]}, #{best[:players]}, #{best[:players].map {|p| p[:price]}.reduce(0, :+)}"
      end
      return best
    end

end