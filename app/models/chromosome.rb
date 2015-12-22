class Chromosome
  
  attr_accessor :genes

  def initialize(genes = "", players = nil)
    if genes == ""
      bases = 3.times.map{ players[:bases][rand(0..players[:bases].count)] } 
      aleros = 4.times.map{ players[:aleros][rand(0..players[:aleros].count)] } 
      pivots = 4.times.map{ players[:pivots][rand(0..players[:pivots].count)] } 
      self.genes = bases + aleros + pivots
    else
      self.genes = genes
    end
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
  
  def mutate!(players = nil)
    mutated = ""
    index = rand(0..10)
    genes_transpose = genes
    sum = genes_transpose.transpose.map {|x| x.min}
    puts sum.to_s

    if rand <= MUTATION_RATE
      case index
      when 0..2
        genes[index] = players[:bases][rand(0..players[:bases].count)]
      when 3..6 
        genes[index] = players[:aleros][rand(0..players[:aleros].count)]
      else
        genes[index] = players[:pivots][rand(0..players[:pivots].count)]
      end        
    end
    mutated = genes
    self.genes = mutated    
  end
  
  def &(other)
    locus = rand(genes.length) + 1

    child1 = genes[0, locus] + other.genes[locus, other.genes.length]
    child2 = other.genes[0, locus] + genes[locus, other.genes.length]

    return [
      Chromosome.new(child1, nil),
      Chromosome.new(child2, nil),
    ]
  end
end