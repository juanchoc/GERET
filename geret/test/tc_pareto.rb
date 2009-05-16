#!/usr/bin/ruby

require 'test/unit'
require 'lib/pareto'

class SingleMax < Struct.new( :value )
  include Pareto
  Pareto.objective SingleMax, :value, :maximize   
end

class SingleMin
  include Pareto

  def initialize initvalue
    @val = initvalue
  end

  def value
    @val
  end
end
Pareto.objective SingleMin, :value, :minimize

class BasicPair < Struct.new( :up, :down )
  include Pareto
  Pareto.objective BasicPair, :down, :minimize
  Pareto.objective BasicPair, :up, :maximize 
end

class SingleProcMin < Struct.new( :data )
  include Pareto
  Pareto.objective :SingleProcMin, :data, proc { |one,two| two.size <=> one.size }
end

class BasicPairFancy < Struct.new( :up, :down )
  include Pareto
  Pareto.minimize BasicPairFancy, :down
  Pareto.maximize BasicPairFancy, :up 
end

class TC_Pareto < Test::Unit::TestCase

  def test_basic_max
    
    i1 = SingleMax.new 42
    i2 = SingleMax.new 42   
    i3 = SingleMax.new 40  

    assert_equal( false, i1.dominates?( i2 ) )
    assert_equal( false, i2.dominates?( i1 ) )
    assert_equal( true, i2.dominates?( i3 ) )
    assert_equal( false, i3.dominates?( i2 ) )

    assert_equal( 0, i1 <=> i2 )
    assert_equal( 0, i2 <=> i1 )
    assert_equal( -1, i2 <=> i3 )
    assert_equal( 1, i3 <=> i2 )
  
  end

  def test_basic_min
    
    i1 = SingleMin.new 42
    i2 = SingleMin.new 42   
    i3 = SingleMin.new 40  

    assert_equal( false, i1.dominates?( i2 ) )
    assert_equal( false, i2.dominates?( i1 ) )
    assert_equal( false, i2.dominates?( i3 ) )
    assert_equal( true, i3.dominates?( i2 ) )

    assert_equal( 0, i1 <=> i2 )
    assert_equal( 0, i2 <=> i1 )
    assert_equal( 1, i2 <=> i3 )
    assert_equal( -1, i3 <=> i2 )
  
  end

  def test_basic_pair

    i1 = BasicPair.new 42, -30
    i2 = BasicPair.new 30, -42   
    assert_equal( 0, i1 <=> i2 )
    assert_equal( 0, i2 <=> i1 )

    i3 = BasicPair.new 42, -42  
    assert_equal( -1, i3 <=> i1 )
    assert_equal( 1, i1 <=> i3 )
    assert_equal( -1, i3 <=> i2 )
    assert_equal( 1, i2 <=> i3 )

    i4 = BasicPair.new 30, -30 
    assert_equal( 1, i4 <=> i1 )
    assert_equal( -1, i1 <=> i4 )
    assert_equal( 1, i4 <=> i2 )
    assert_equal( -1, i2 <=> i4 )

    i5 = BasicPair.new 30, -30   
    assert_equal( 0, i5 <=> i4 )
    assert_equal( 0, i4 <=> i5 )
 
  end

  def test_proc_min
    
    i1 = SingleProcMin.new [1,3,0,5]
    i2 = SingleProcMin.new [nil, '', 'ok', nil]
    i3 = SingleProcMin.new [1000,"2000"]  

    assert_equal( 0, i1 <=> i2 )
    assert_equal( 0, i2 <=> i1 )
    assert_equal( 1, i2 <=> i3 )
    assert_equal( -1, i3 <=> i2 )
  
  end

  def test_pair_fancy

    i1 = BasicPairFancy.new 42, -30
    i2 = BasicPairFancy.new 30, -42   
    assert_equal( 0, i1 <=> i2 )
    assert_equal( 0, i2 <=> i1 )

    i3 = BasicPairFancy.new 42, -42  
    assert_equal( -1, i3 <=> i1 )
    assert_equal( 1, i1 <=> i3 )
    assert_equal( -1, i3 <=> i2 )
    assert_equal( 1, i2 <=> i3 )

    i4 = BasicPairFancy.new 30, -30 
    assert_equal( 1, i4 <=> i1 )
    assert_equal( -1, i1 <=> i4 )
    assert_equal( 1, i4 <=> i2 )
    assert_equal( -1, i2 <=> i4 )

    i5 = BasicPairFancy.new 30, -30   
    assert_equal( 0, i5 <=> i4 )
    assert_equal( 0, i4 <=> i5 )
 
  end

  def test_pareto_objective_symbols
    assert_equal( [:down, :up], Pareto.objective_symbols( BasicPair ) )
    assert_equal( [:down, :up], BasicPair.new.objective_symbols )
    assert_equal( [:data], SingleProcMin.new.objective_symbols )
  end
 
  def test_objective_sorting
    population = []
    population << BasicPair.new( 42, -30 )
    population << BasicPair.new( 30, -12 )
    population << BasicPair.new(  5, -32 )
    population << BasicPair.new( 25, -10 )

    ups = Pareto.objective_sort( population, BasicPair, :up )
    assert_equal( 4, ups.size ) 
    assert_equal( population[0], ups[0] )
    assert_equal( population[1], ups[1] )
    assert_equal( population[3], ups[2] )   
    assert_equal( population[2], ups[3] )

    downs = Pareto.objective_sort( population, BasicPair, :down )
    assert_equal( 4, downs.size ) 
    assert_equal( population[2], downs[0] )
    assert_equal( population[0], downs[1] )
    assert_equal( population[1], downs[2] )   
    assert_equal( population[3], downs[3] )
  end

end

