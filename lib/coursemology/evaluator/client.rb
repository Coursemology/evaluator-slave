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

    loop do
      allocate_evaluations
      break if @terminate

      sleep(1.minute)
    end
  end

  private

  # Requests evaluations from the server.
  def allocate_evaluations
    evaluations = Coursemology::Evaluator::Models::ProgrammingEvaluation.allocate
    on_allocate(evaluations)
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
    evaluation.evaluate
    evaluation.save
  end

  # The callback for handling SIGTERM sent to the process.
  def on_sig_term
    @terminate = true
  end
end
