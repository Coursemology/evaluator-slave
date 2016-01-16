require 'active_support/all'
require 'active_rest_client'
require 'faraday_middleware'
require 'docker'
Docker.validate_version!

require 'coursemology/polyglot'
require 'coursemology/polyglot/extensions'
require 'coursemology/evaluator/version'

module Coursemology::Evaluator
  extend ActiveSupport::Autoload

  autoload :Client
  autoload :CLI
  autoload :Models
  autoload :Services
end
