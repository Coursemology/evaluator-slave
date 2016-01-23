class Coursemology::Evaluator::Services::EvaluateProgrammingPackageService
  Result = Struct.new(:stdout, :stderr, :test_report)

  # The path to the Coursemology user home directory.
  HOME_PATH = '/home/coursemology'.freeze

  # The path to where the package will be extracted.
  PACKAGE_PATH = File.join(HOME_PATH, 'package')

  # The path to where the test report will be at.
  REPORT_PATH = File.join(PACKAGE_PATH, 'report.xml')

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

    extract_result(container)
  ensure
    destroy_container(container) if container
  end

  def create_container(image)
    image_identifier = "coursemology/evaluator-image-#{image}"
    ActiveSupport::Notifications.instrument('pull.docker.evaluator.coursemology',
                                            image: image_identifier) do
      Docker::Image.create('fromImage' => image_identifier)
    end

    ActiveSupport::Notifications.instrument('create.docker.evaluator.coursemology',
                                            image: image_identifier) do |payload|
      payload[:container] = Docker::Container.create('Image' => image_identifier)
    end
  end

  # Copies the contents of the package to the container.
  #
  # @param [Docker::Container] container The container to copy the package into.
  def copy_package(container)
    tar = tar_package(@package)
    container.archive_in_stream(HOME_PATH) do
      tar.read(Excon.defaults[:chunk_size]).to_s
    end
  end

  # Converts the zip package into a tar package for the container.
  #
  # This also adds an additional +package+ directory to the start of the path, following tar
  # convention.
  #
  # @param [Coursemology::Evaluator::Models::ProgrammingEvaluation::Package] package The package
  #   to convert to a tar.
  # @return [IO] A stream containing the tar.
  def tar_package(package)
    tar_file_stream = StringIO.new
    tar_file = Gem::Package::TarWriter.new(tar_file_stream)
    Zip::File.open_buffer(package.stream) do |zip_file|
      copy_archive(zip_file, tar_file, File.basename(PACKAGE_PATH))
      tar_file.close
    end

    tar_file_stream.seek(0)
    tar_file_stream
  end

  # Copies every entry from the zip archive to the tar archive, adding the optional prefix to the
  # start of each file name.
  #
  # @param [Zip::File] zip_file The zip file to read from.
  # @param [Gem::Package::TarWriter] tar_file The tar file to write to.
  # @param [String] prefix The prefix to add to every file name in the tar.
  def copy_archive(zip_file, tar_file, prefix = nil)
    zip_file.each do |entry|
      next unless entry.file?

      zip_entry_stream = entry.get_input_stream
      new_entry_name = prefix ? File.join(prefix, entry.name) : entry.name
      tar_file.add_file(new_entry_name, 0664) do |tar_entry_stream|
        IO.copy_stream(zip_entry_stream, tar_entry_stream)
      end

      zip_entry_stream.close
    end
  end

  def execute_package(container)
    container.start!
    execute_package_wait(container)
  end

  # Waits for the container to exit the Running state.
  #
  # This will time out for long running operations, so keep retrying until we return.
  def execute_package_wait(container)
    container_state = container.info
    while container_state.fetch('State', {}).fetch('Running', true)
      container.wait
      container.refresh!
      container_state = container.info
    end
  rescue Docker::Error::TimeoutError
    retry
  end

  def extract_result(container)
    logs = container.logs(stdout: true, stderr: true)

    _, stdout, stderr = Coursemology::Evaluator::Utils.parse_docker_stream(logs)
    Result.new(stdout, stderr, extract_test_report(container))
  end

  def extract_test_report(container)
    stream = extract_test_report_archive(container)

    tar_file = Gem::Package::TarReader.new(stream)
    tar_file.each do |file|
      return file.read
    end
  rescue Docker::Error::NotFoundError
    return nil
  end

  # Extracts the test report from the container.
  #
  # @return [StringIO] The stream containing the archive, the pointer is reset to the start of the
  #   stream.
  def extract_test_report_archive(container)
    stream = StringIO.new
    container.archive_out(REPORT_PATH) do |bytes|
      stream.write(bytes)
    end

    stream.seek(0)
    stream
  end

  def destroy_container(container)
    ActiveSupport::Notifications.instrument('destroy.docker.evaluator.coursemology',
                                            container: container.id) do
      container.delete
    end
  end
end
