class Population
  
  attr_accessor :chromosomes
  
  def initialize 
    self.chromosomes = Array.new
  end
  
  def inspect
    chromosomes.join(" ")
  end
  
  def seed! all_players
    chromosomes = Array.new
    1.upto(POPULATION_SIZE).each do
      chromosomes << Chromosome.new("", all_players)
    end

    self.chromosomes = chromosomes    
  end
  
  def count
    chromosomes.count
  end
  
  def fitness_values
    puts "fitness_values--"
    chromosomes.collect(&:fitness)
  end
  
  def total_fitness
    puts "TOTAL FITNESS"
    #puts fitness_values
    #puts fitness_values.first
    puts fitness_values.first[:total]
    fitness_values.inject{|total, value| total + (value[:total] || 0) }
  end
  
  def max_fitness
    puts "MAX FITNESS ---"
    puts fitness_values
    fitness_values.max
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