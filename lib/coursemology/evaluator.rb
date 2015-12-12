require 'active_support/all'
require 'active_rest_client'
require 'coursemology/evaluator/version'

module Coursemology::Evaluator
  extend ActiveSupport::Autoload

  autoload :Client
  autoload :CLI
  autoload :Models
end
