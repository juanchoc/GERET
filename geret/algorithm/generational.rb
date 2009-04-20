
include Selection

class Generational

  attr_accessor :termination, :init, :population_size, :elite_size, :crossover_probability, :mutation_probability

  def initialize
  end

  def setup config
    raise "Generational: elite_size >= population_size" if @elite_size >= @population_size

    @cfg = config
    @report = @cfg.factory('report')
    @report << "--------- initialization:"
    
    @store = @cfg.factory('store')
    @grammar = @cfg.factory('grammar')
    @mapper = @cfg.factory('mapper', @grammar)
    @selection = @cfg['selection_rank'].nil? ? 
                 @cfg.factory('selection') : 
                 @cfg.factory('selection', @cfg.factory('selection_rank') ) 
    @elite_rank = @cfg.factory('elite_rank')     
    @crossover = @cfg.factory('crossover')
    @mutation = @cfg.factory('mutation')   

    @population = @store.load
    @population = [] if @population.nil?
    @report << "loaded #{@population.size} individuals"   
    @report << "creating #{@population_size - @population.size} individuals"     
    while @population.size < @population_size
      individual = @cfg.factory( 'individual', @mapper, init_chromozome(@init['method']) )
      @population << individual if individual.valid? 
    end

    @steps = 0

    return @report    
  end

  def teardown
    @report << "--------- finished:"
    @store.save @population
    return @report   
  end

  def step
    @report << "--------- step #{@steps += 1}" 

    ranked_population = ( @elite_rank.rank @population ).map { |ranked| ranked.original }
    @report.report ranked_population
       
    new_population = ranked_population[0...@elite_size]  
       
    @selection.population = @population  

    cross, inject, mutate = 0, 0, 0
    while new_population.size < @population_size
      if rand < @crossover_probability 
        parents = @selection.select 2 
        chromozome, dummy = @crossover.crossover( parents.first.genotype, parents.last.genotype ) 
        cross += 1
      else
        #chromozome = @selection.select_one.genotype 
        chromozome = init_chromozome @init['method']
        inject += 1
      end
   
      if rand < @mutation_probability
        chromozome = @mutation.mutation chromozome   
        mutate += 1
      end
      
      individual = @cfg.factory( 'individual', @mapper, chromozome ) 
      new_population << individual if individual.valid?
    end

    @report['numof_crossovers'] << cross   
    @report['numof_injections'] << inject
    @report['numof_mutations'] << mutate
    @population = new_population

    @report.next   
    return @report
  end

  def finished?
    if ( ! @termination['max_steps'].nil? and @steps >= @termination['max_steps'] ) or
       ( ! @termination['on_individual'].nil? and @population.detect { |individual| individual.send @termination['on_individual'] } )
 
      ranked_population = ( @elite_rank.rank @population ).map { |ranked| ranked.original }
      @report.report ranked_population

      return true
    end
    return false
  end

  protected

  def init_chromozome method
    case method
    when 'random'
      RandomInit.new( @init['random_magnitude'] ).init( @init['random_length'] )
    when 'grow'
      @mapper.generate_grow @init['sensible_depth']
    when 'full'
      @mapper.generate_full @init['sensible_depth']
    else
      raise "Generational: init method #{method} not implemented"
    end
  end

end

