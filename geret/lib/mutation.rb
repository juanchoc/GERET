
# Simple mutation. It assumes the source genotype has the form of the Array of numbers.
#
class Mutation

  # Create the mutation operator with default settings.
  def initialize magnitude=nil
    @random = Kernel
    @magnitude = magnitude
  end

  # the source of randomness, used for calling "random.rand( limit )", defaulting to 'Kernel' class.
  attr_accessor :random

  # the maximal possible value of the mutaton. If not specified, the maximal value over the original genotype values is used.
  attr_accessor :magnitude

  # Select the random position within the orig vector and mutate it.
  # The resultant value (of a mutated codon) is a random number in the range 0..magnitude.
  # Return the mutated copy of the orig. genotype.
  def mutation orig
    mutant = orig.clone
    max = @magnitude.nil? ? mutant.max+1 : @magnitude
    where = @random.rand( orig.size )
    mutant[ where ] = @random.rand( max )
    mutant
  end

end

