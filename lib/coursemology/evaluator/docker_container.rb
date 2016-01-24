class Coursemology::Evaluator::DockerContainer < Docker::Container
  class << self
    def create(image, argv: nil)
      pull_image(image)

      ActiveSupport::Notifications.instrument('create.docker.evaluator.coursemology',
                                              image: image) do |payload|
        options = { 'Image' => image }
        options['Cmd'] = argv if argv && !argv.empty?

        payload[:container] = super(options)
      end
    end

    private

    def pull_image(image)
      ActiveSupport::Notifications.instrument('pull.docker.evaluator.coursemology',
                                              image: image) do
        Docker::Image.create('fromImage' => image)
      end
    end
  end

  # Waits for the container to exit the Running state.
  #
  # This will time out for long running operations, so keep retrying until we return.
  #
  # @param [Fixnum|nil] time The amount of time to wait.
  # @return [Fixnum] The exit code of the container.
  def wait(time = nil)
    container_state = info
    while container_state.fetch('State', {}).fetch('Running', true)
      super
      refresh!
      container_state = info
    end

    container_state['State']['ExitCode']
  rescue Docker::Error::TimeoutError
    retry
  end

  # Gets the exit code of the container.
  #
  # @return [Fixnum] The exit code of the container, if +wait+ was called before.
  # @return [nil] If the container is still running, or +wait+ was not called.
  def exit_code
    info.fetch('State', {})['ExitCode']
  end

  def delete
    ActiveSupport::Notifications.instrument('destroy.docker.evaluator.coursemology',
                                            container: id) do
      super
    end
  end
end
