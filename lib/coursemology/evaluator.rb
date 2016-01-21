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
  autoload :Models
  autoload :Services

  eager_autoload do
    autoload :Logging
  end

  # The logger to use for the client.
  mattr_reader(:logger) { ActiveSupport::Logger.new(STDOUT) }

  # Application cache, like Rails. Currently nil.
  mattr_reader(:cache)

  def self.eager_load!
    super
    Coursemology::Polyglot.eager_load!
    Logging.eager_load!
  end
end
