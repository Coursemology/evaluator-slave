require 'active_support/all'
require 'active_rest_client'
require 'faraday_middleware'
require 'docker'
require 'zip'
Docker.validate_version!

require 'coursemology/polyglot'
require 'coursemology/polyglot/extensions'
require 'coursemology/evaluator/version'

module Coursemology::Evaluator
  extend ActiveSupport::Autoload

  autoload :Client
  autoload :CLI
  autoload :Logging
  autoload :Models
  autoload :Services
  autoload :StringIO

  # The logger to use for the client.
  mattr_reader(:logger) { ActiveSupport::Logger.new(STDOUT) }
  Logging.start

  # Application cache, like Rails. Currently nil.
  mattr_reader(:cache)
end
