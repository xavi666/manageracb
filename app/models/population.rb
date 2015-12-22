class Population
  
  attr_accessor :chromosomes, :max_price, :all_players
  
  def initialize max_price, all_players
    self.chromosomes = Array.new
    self.max_price = max_price
    self.all_players = all_players
  end
  
  def inspect
    chromosomes.join(" ")
  end
  
  def seed!
    chromosomes = Array.new
    1.upto(POPULATION_SIZE).each do
      chromosomes << Chromosome.new("", self.all_players)
    end

    self.chromosomes = chromosomes    
  end
  
  def count
    chromosomes.count
  end
  
  def fitness_values
    chromosomes.collect(&:fitness)
  end

  def total_fitness
    fitness_values.inject{|total, value| total + value }
  end
  
  def max_fitness
    fitness_values.max
  end

  def max_fitness_ids
    chromosomes.each do |chromosoma|
      ids = []
      total = 0
      0.upto(chromosoma.genes.count - 1).each do |i|
        unless chromosoma.genes[i].nil?
          id = chromosoma.genes[i].first
          value = chromosoma.genes[i].second.to_s.blank? ? 0 : chromosoma.genes[i].second
          total += value 
          ids.push(id)
        end
      end
      return ids if total == max_fitness
    end
  end
  
  def average_fitness
    total_fitness.to_f / chromosomes.length.to_f
  end
  
  def select
    rand_selection = rand(total_fitness)
    total = 0
    chromosomes.each_with_index do |chromosome, index|
      total += chromosome.fitness
      return chromosome if total > rand_selection || index == chromosomes.count - 1
    end
  end
end