
require 'lib/grammar'

module Abnf
 
  # Abnf::Renderer renders the ABNF syntax tree from the Mapper::Grammar.
  class Renderer

    # If the grammar provided is the valid Mapper::Grammar instance, Renderer.canonical method
    # returns the formatted ABNF text.
    def Renderer.canonical grammar
      start = grammar.start_symbol
      res = ";start symbol is <#{start}>\n"
      symbols = grammar.symbols
      symbols.delete start
      symbols.unshift start
      symbols.each do |name|
        rule = grammar.fetch name
        rule.each do |alt|
          res += ( name + ' =' )
          res += '/' if alt != rule.first
          alt.each do |token|
            res += ' ';
            case token.type
            when :literal
              res += ('"' + token.data + '"')
            when :symbol
              res += token.data
            else
              raise "unsupported token.type=#{token.type}"
            end
          end
          res += "\n"
        end
        res += "\n"
      end
      res
    end

  end

end

