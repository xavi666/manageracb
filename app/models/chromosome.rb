class Chromosome
  
  attr_accessor :genes

  def initialize(genes = "", players = nil)
    if genes == ""
      #self.genes = (1..NUM_BITS).map{ rand(2) }.join
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
    result = {total: 0, values: []}
    total = 0
    values = []
    0.upto(genes.count - 1).each do |i|
      unless genes[i].nil?
        id = genes[i].first
        value = genes[i].second.to_s.blank? ? 0 : genes[i].second
        result[:total] = result[:total] + value
        result[:values].push(id)
      end
    end
    result
  end
  
  def mutate!(players = nil)
    mutated = ""
    0.upto(genes.count - 1).each do |i|
      if rand <= MUTATION_RATE
        case i
        when 0..2
          genes[i] = players[:bases][rand(0..players[:bases].count)]
        when 3..6 
          genes[i] = players[:bases][rand(0..players[:aleros].count)]
        else
          genes[i] = players[:bases][rand(0..players[:pivots].count)]
        end        
      end
      mutated = genes
    end
  
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