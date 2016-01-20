class Coursemology::Evaluator::Logging::ClientLogSubscriber < ActiveSupport::LogSubscriber
  def self.subscribe
    attach_to(:'client.evaluator.coursemology')
  end

  def allocate(event)
    info color("Client: Allocate (#{event.duration.round(1)}ms)", MAGENTA)
  end

  def evaluate(event)
    info "#{color("Client: Evaluate (#{event.duration.round(1)}ms)", CYAN)} "\
      "#{event.payload[:evaluation].language.class.display_name}"
  end

  def save(event)
    info color("Client: Save (#{event.duration.round(1)}ms)", GREEN)
  end
end
