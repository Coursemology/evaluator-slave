class Coursemology::Evaluator::Services::EvaluateProgrammingPackageService
  Result = Struct.new(:stdout, :stderr, :test_report)

  # The path to the Coursemology user home directory.
  HOME_PATH = '/home/coursemology'.freeze

  # The path to where the package will be extracted.
  PACKAGE_PATH = File.join(HOME_PATH, 'package')

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

  # Evaluates the package.
  #
  # @return [Coursemology::Evaluator::Services::EvaluateProgrammingPackageService::Result]
  def execute
    container = create_container(@evaluation.language.class.docker_image)
    copy_package(container)
    execute_package(container)

    Result.new(container.logs(stdout: true), container.logs(stderr: true),
               extract_test_report(container))
  ensure
    container.delete
  end

  def create_container(image)
    image_identifier = "coursemology/evaluator-image-#{image}"
    Docker::Image.create('fromImage' => image_identifier)
    Docker::Container.create('Image' => image_identifier)
  end

  def copy_package(container)
  end

  def execute_package(container)
  end

  def extract_test_report(container)
  end
end
