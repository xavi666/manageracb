#http://mattmazur.com/2013/08/18/a-simple-genetic-algorithm-written-in-ruby/

POPULATION_SIZE = 10
NUM_BITS = 64
NUM_GENERATIONS = 10
CROSSOVER_RATE = 2
MUTATION_RATE = 20

class OptimizationsController < ApplicationController

  def index

    population = Population.new
    population.seed!

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

        child1.mutate!
        child2.mutate!
        
        if POPULATION_SIZE.even?
          offspring.chromosomes << child1 << child2
        else
          offspring.chromosomes << [child1, child2].sample
        end
      end

      puts "Generation #{generation} - Average: #{population.average_fitness.round(2)} - Max: #{population.max_fitness}"

      population = offspring
    end
    @population

    puts "Final population: " + @population.inspect
  end

end