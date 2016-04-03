# frozen_string_literal: true
class Coursemology::Evaluator::Client
  def self.initialize(host, api_user_email, api_token)
    Coursemology::Evaluator::Models::Base.base_url = host
    Coursemology::Evaluator::Models::Base.api_user_email = api_user_email
    Coursemology::Evaluator::Models::Base.api_token = api_token

    Coursemology::Evaluator::Models::Base.initialize
  end

  # @param [Boolean] one_shot If the client should only fire one request.
  def initialize(one_shot = false)
    @terminate = one_shot
  end

  def run
    Signal.trap('SIGTERM', method(:on_sig_term))
    loop(&method(:client_loop))
  end

  private

  # Performs one iteration of the client loop.
  def client_loop
    evaluations = allocate_evaluations
    if evaluations && !evaluations.empty?
      on_allocate(evaluations)
    else
      raise StopIteration if @terminate

      # :nocov:
      # This sleep might not be triggered in the specs, because interruptions to the thread is
      # nondeterministically run by the OS scheduler.
      sleep(1.minute)
      # :nocov:
    end

    raise StopIteration if @terminate
  end

  # Requests evaluations from the server.
  #
  # @return [Array<Coursemology::Evaluator::Models::ProgrammingEvaluation>] The evaluations
  #   retrieved from the server.
  def allocate_evaluations
    ActiveSupport::Notifications.instrument('allocate.client.evaluator.coursemology') do
      languages = Coursemology::Polyglot::Language.concrete_languages.map(&:display_name)
      Coursemology::Evaluator::Models::ProgrammingEvaluation.allocate(language: languages)
    end
  rescue Flexirest::HTTPUnauthorisedClientException => e
    ActiveSupport::Notifications.publish('allocate_fail.client.evaluator.coursemology', e: e)
    nil
  end

  # The callback for handling an array of allocated evaluations.
  #
  # @param [Array<Coursemology::Evaluator::Models::ProgrammingEvaluation>] evaluations The
  #   evaluations retrieved from the server.
  def on_allocate(evaluations)
    evaluations.each do |evaluation|
      on_evaluation(evaluation)
    end
  end

  # The callback for handling an evaluation.
  #
  # @param [Coursemology::Evaluator::Models::ProgrammingEvaluation] evaluation The evaluation
  #   retrieved from the server.
  def on_evaluation(evaluation)
    ActiveSupport::Notifications.instrument('evaluate.client.evaluator.coursemology',
                                            evaluation: evaluation) do
      evaluation.evaluate
    end

    ActiveSupport::Notifications.instrument('save.client.evaluator.coursemology') do
      evaluation.save
    end
  end

  # The callback for handling SIGTERM sent to the process.
  def on_sig_term
    @terminate = true
  end
end
