module Coursemology::Evaluator::Logging
  extend ActiveSupport::Autoload

  autoload :ClientLogSubscriber
  autoload :DockerLogSubscriber

  def self.start
    DockerLogSubscriber.subscribe
    ClientLogSubscriber.subscribe
  end
end

# Define +Rails+ to trick ActiveSupport into logging to our logger.
Rails = Coursemology::Evaluator
