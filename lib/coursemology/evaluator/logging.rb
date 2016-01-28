# frozen_string_literal: true
module Coursemology::Evaluator::Logging
  extend ActiveSupport::Autoload

  eager_autoload do
    autoload :ClientLogSubscriber
    autoload :DockerLogSubscriber
  end
end

# Define +Rails+ to trick ActiveSupport into logging to our logger.
Rails = Coursemology::Evaluator
