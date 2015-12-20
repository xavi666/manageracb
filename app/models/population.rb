class Population
  
  attr_accessor :chromosomes, :initial_genes, :all_players
  
  def initialize 
    self.chromosomes = Array.new
  end
  
  def inspect
    chromosomes.join(" ")
  end
  
  def seed! all_players
    chromosomes = Array.new
    1.upto(POPULATION_SIZE).each do
      chromosomes << Chromosome.new(self.initial_genes)
    end
    self.chromosomes = chromosomes    
    puts "CROMOSOMES"
    puts chromosomes.inspect
  end
  
  def count
    chromosomes.count
  end
  
  def fitness_values
    chromosomes.collect(&:fitness)
  end

  def fitness_ids
    chromosomes.collect(&:fitness_ids)
  end 

  def total_fitness
    fitness_values.inject{|total, value| total + value }
  end
  
  def max_fitness
    fitness_values.max
  end

  def max_fitness_ids
    fitness_ids.max
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