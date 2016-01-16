class Coursemology::Evaluator::Services::EvaluateProgrammingPackageService
  Result = Struct.new(:stdout, :stderr, :test_report)

  # Executes the given package in a container.
  #
  # @param [Coursemology::Evaluator::Models::ProgrammingEvaluation] evaluation The evaluation
  #   from the server.
  # @return [Coursemology::Evaluator::Services::EvaluateProgrammingPackageService::Result] The
  #   result of the evaluation.
  def self.execute(evaluation)
    new(evaluation).send(:execute)
  end

  # Creates a new service object.
  def initialize(evaluation)
    @evaluation = evaluation
    @package = evaluation.package
  end

  private

  def execute
    Result.new('', '', '')
  end
end
