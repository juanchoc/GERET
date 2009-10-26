
# The common "require proxy" for GERET library.
# Please add require statement for every new dependency which should be considered as a part of lib/* or algorithm/*

require 'lib/abnf_renderer'
require 'lib/abnf_file'
require 'lib/config'
require 'lib/crossover_ripple'
require 'lib/crossover_lhs'
require 'lib/dominance'
require 'lib/mapper'
require 'lib/mutation_ripple'
require 'lib/mutation_altering'
require 'lib/crowding'
require 'lib/random_init'
require 'lib/report'
require 'lib/rank_roulette'
require 'lib/rank_sampling'
require 'lib/shorten'
require 'lib/store'
require 'lib/tournament'
require 'lib/utils'
require 'lib/validator'
require 'lib/individual'
require 'lib/truncation'
require 'lib/round_robin'
require 'lib/pareto_tourney'
require 'lib/work_pipes'
require 'lib/piped_individual'

require 'algorithm/generational'
require 'algorithm/steady_state'
require 'algorithm/mu_lambda'
require 'algorithm/paretogp_simplified'
require 'algorithm/nsga2'
require 'algorithm/spea2'

require 'algorithm/support/population_report'

