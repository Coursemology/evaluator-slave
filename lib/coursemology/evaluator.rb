# frozen_string_literal: true
require 'active_support/all'
require 'flexirest'
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
  autoload :DockerContainer
  autoload :CLI
  autoload :Models
  autoload :Services
  autoload :StringIO
  autoload :Utils

  eager_autoload do
    autoload :Logging
  end

  # The logger to use for the client.
  mattr_reader(:logger) { ActiveSupport::Logger.new(STDOUT) }

  # The cache to use for the client.
  mattr_reader(:cache) { ActiveSupport::Cache.lookup_store }

  def self.eager_load!
    super
    Coursemology::Polyglot.eager_load!
    Logging.eager_load!
  end
end
