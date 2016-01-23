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

  def delete
    ActiveSupport::Notifications.instrument('destroy.docker.evaluator.coursemology',
                                            container: id) do
      super
    end
  end
end
