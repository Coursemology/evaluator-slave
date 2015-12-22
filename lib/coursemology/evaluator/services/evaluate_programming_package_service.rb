class Coursemology::Evaluator::Services::EvaluateProgrammingPackageService
  Result = Struct.new(:stdout, :stderr, :test_report)

  # Executes the given package in a container.
  #
  # @param [Coursemology::Evaluator::Models::ProgrammingEvaluation::Package] package The package
  #   to evaluate.
  # @return [Coursemology::Evaluator::Services::EvaluateProgrammingPackageService::Result] The
  #   result of the evaluation.
  def self.execute(package)
    new(package).send(:execute)
  end

  # Creates a new service object.
  def initialize(package)
    @package = package
  end

  private

  def execute
    Result.new('', '', '')
  end
end
