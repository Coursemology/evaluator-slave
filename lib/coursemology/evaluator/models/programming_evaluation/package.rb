# frozen_string_literal: true
class Coursemology::Evaluator::Models::ProgrammingEvaluation::Package
  # The stream comprising the package.
  attr_reader :stream

  # Constructs a new Package.
  #
  # @param [IO] stream The stream comprising the package.
  def initialize(stream)
    @stream = stream
  end
end
