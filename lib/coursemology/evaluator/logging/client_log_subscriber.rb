# frozen_string_literal: true
class Coursemology::Evaluator::Logging::ClientLogSubscriber < ActiveSupport::LogSubscriber
  def publish(name, *args)
    send(name.split('.').first, *args)
  end

  def allocate(event)
    info color("Client: Allocate (#{event.duration.round(1)}ms)", MAGENTA)
  end

  def allocate_fail(e:)
    error color("Client: Allocate failed: #{e.message}", RED)
  end

  def evaluate(event)
    info "#{color("Client: Evaluate (#{event.duration.round(1)}ms)", CYAN)} "\
      "#{event.payload[:evaluation].language.class.display_name}"
  end

  def save(event)
    info color("Client: Save (#{event.duration.round(1)}ms)", GREEN)
  end
end

Coursemology::Evaluator::Logging::ClientLogSubscriber.attach_to(:'client.evaluator.coursemology')
