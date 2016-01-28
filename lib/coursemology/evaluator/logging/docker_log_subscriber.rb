# frozen_string_literal: true
class Coursemology::Evaluator::Logging::DockerLogSubscriber < ActiveSupport::LogSubscriber
  def pull(event)
    info "#{color("Docker Pull (#{event.duration.round(1)}ms)", GREEN)} #{event.payload[:image]}"
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

Coursemology::Evaluator::Logging::DockerLogSubscriber.attach_to(:'docker.evaluator.coursemology')
