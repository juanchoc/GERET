#!/usr/bin/ruby -w

require 'test/tc_mock_rand'
require 'test/tc_grammar'
require 'test/tc_abnf_tokenizer'
require 'test/tc_abnf_parser'
require 'test/tc_abnf_renderer'
require 'test/tc_abnf_file'
require 'test/tc_mappers'
require 'test/tc_generators'
require 'test/tc_validator'
require 'test/tc_pareto'
require 'test/tc_crossover_ripple'
require 'test/tc_mutation_ripple'
require 'test/tc_mutation_altering'
require 'test/tc_shorten'
require 'test/tc_random_init'
require 'test/tc_ranking'
require 'test/tc_dominance'
require 'test/tc_roulette'
require 'test/tc_rank_roulette'
require 'test/tc_sampling'
require 'test/tc_rank_sampling'
require 'test/tc_tournament'
require 'test/tc_utils'
require 'test/tc_config'
require 'test/tc_store'
require 'test/tc_report'
require 'test/tc_individual'
require 'test/tc_truncation'
require 'test/tc_round_robin'
require 'test/tc_pareto_tourney'
require 'test/tc_crowding'
require 'test/tc_crossover_lhs'
require 'test/tc_work_pipes'
require 'test/tc_piped_individual'
require 'test/tc_semantic_functions'
require 'test/tc_semantic_edges'
require 'test/tc_attribute_grammar'
require 'test/tc_alps_individual.rb'
require 'test/tc_codon_mod'
require 'test/tc_codon_bucket'
require 'test/tc_codon_gray'
require 'test/tc_crossover_twopoints'
