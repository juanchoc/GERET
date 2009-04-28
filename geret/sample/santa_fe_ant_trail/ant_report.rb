
class AntReport < ReportText 

  def report population
    diversity = Utils.diversity( population ) { |individual| individual.genotype }
    self['diversity_genotypic'] << diversity[0...10].inspect   
    
    diversity =  Utils.diversity( population ) { |individual| individual.phenotype }
    self['diversity_phenotypic'] << diversity[0...10].inspect

    min, max, avg, n = Utils.statistics( population.map { |individual| individual.fitness } )
    self['fitness_max'] << max
    self['fitness_avg'] << avg

    min, max, avg, n = Utils.statistics( population.map { |individual| individual.used_length } )
    self['usedlen_min'] << min
    self['usedlen_max'] << max
    self['usedlen_avg'] << avg

    min, max, avg, n = Utils.statistics( population.map { |individual| individual.genotype.size } )
    self['gensize_min'] << min
    self['gensize_max'] << max
    self['gensize_avg'] << avg

    best = population.min # assuming individual_1 <=> individual_2
    self['best_phenotype'] << "\n#{best.phenotype}"
  end

end

