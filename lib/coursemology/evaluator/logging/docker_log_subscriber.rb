class Coursemology::Evaluator::Logging::DockerLogSubscriber < ActiveSupport::LogSubscriber
  def self.subscribe
    attach_to(:'docker.evaluator.coursemology')
  end

  def create(event)
    info "#{color("Docker Create (#{event.duration.round(1)}ms)", MAGENTA)} "\
      "#{event.payload[:image]} => #{event.payload[:container].id}"
  end

  def destroy(event)
    info "#{color("Docker Destroy (#{event.duration.round(1)}ms)", CYAN)} "\
      "#{event.payload[:container]}"
  end
end
