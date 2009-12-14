#!/usr/bin/ruby

require 'lib/abnf_file'
require 'lib/validator'

def format_syms symbols
  symbols.map{|s| "<#{s}>"}.join(', ')
end

###

abort "use:\n #$0 some.abnf\n" unless ARGV.size==1

g = Abnf::File.new ARGV[0]  
puts "start symbol: <#{g.start_symbol}>"
undefined = Mapper::Validator.check_undefined g
puts "undefined symbols: " + format_syms( undefined )
unused = Mapper::Validator.check_unused g
puts "not referenced symbols: " + format_syms( unused )
puts ''

abort "recursivity cannot be analyzed." unless undefined.empty? 

g = Mapper::Validator.analyze_recursivity( g )
puts "recursivity :terminating symbols: " + format_syms( g.symbols.find_all {|s| g[s].recursivity == :terminating } )
puts "recursivity :cyclic symbols: " + format_syms( g.symbols.find_all {|s| g[s].recursivity == :cyclic } )
puts "recursivity :infinite symbols: " + format_syms( g.symbols.find_all {|s| g[s].recursivity == :infinite } )
puts "grammar is #{g[g.start_symbol].recursivity}."
puts ''

Validator.analyze_sn_altering g
puts "altering :structural symbols: " + format_syms( g.symbols.find_all {|s| g[s].sn_altering == :structural } )
puts "altering :nodal symbols: " + format_syms( g.symbols.find_all {|s| g[s].sn_altering == :nodal } )

