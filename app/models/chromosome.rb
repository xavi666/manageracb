class Chromosome
  
  attr_accessor :genes

  def initialize(genes = "")
    puts "INITIALIZE"
    puts genes.to_s
    self.genes = genes
  end
  
  def to_s
    genes.to_s
  end
  
  def count
    genes.count
  end
  
  def fitness
    total = 0
    0.upto(genes.count - 1).each do |i|
      unless genes[i].nil?
        id = genes[i].first
        value = genes[i].second.to_s.blank? ? 0 : genes[i].second
        total += value
      end
    end
    total
  end

  def fitness_ids
    ids = []
    0.upto(genes.count - 1).each do |i|
      unless genes[i].nil?
        id = genes[i].first
        value = genes[i].second.to_s.blank? ? 0 : genes[i].second
        ids.push(id)
      end
    end
    ids
  end
  
  def mutate!(players = nil)
    puts "INIT--- MUTATE"
    puts genes.to_s
    1.upto(3).each do |i|
      if rand <= MUTATION_RATE
        index_player = rand(0..10)
        case index_player
        when 0..2
          genes[index_player] = players[:bases][rand(0..players[:bases].count-1)]
        when 3..6 
          genes[index_player] = players[:aleros][rand(0..players[:aleros].count-1)]
        else
          genes[index_player] = players[:pivots][rand(0..players[:pivots].count-1)]
        end 
      end
    end
    puts genes.to_s
    puts "END--- MUTATE"
    #0.upto(genes.count - 1).each do |i|
    #  if rand <= MUTATION_RATE
    #    case i
    #    when 0..2
    #      genes[i] = players[:bases][rand(0..players[:bases].count-1)]
    #    when 3..6 
    #      genes[i] = players[:aleros][rand(0..players[:aleros].count-1)]
    #    else
    #      genes[i] = players[:pivots][rand(0..players[:pivots].count-1)]
    #    end        
    #  end
    #  mutated = genes
    #end
  
    #mutated = ""
    #puts "size = "+genes.length.to_s
    #0.upto(genes.length - 1).each do |i|
    #  allele = genes[i, 1]
    #  puts genes[i].to_s+" = "+allele
    #  if rand <= MUTATION_RATE
    #    mutated += (allele == "0") ? "1" : "0"
    #  else
    #    mutated += allele
    #  end
    #end
    #puts "genes  = "+self.genes.to_s
    #puts "mutated ="+mutated

    self.genes = genes    
  end
  
  def &(other)
    locus = rand(genes.length) + 1

    puts "CHILDS"

    child1 = genes[0, locus] + other.genes[locus, other.genes.length]
    child2 = other.genes[0, locus] + genes[locus, other.genes.length]
    puts child1.to_s

    return [
      Chromosome.new(child1),
      Chromosome.new(child2),
    ]
  end
end