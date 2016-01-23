module ProgrammingEvaluationFactory
  def self.define_package(evaluation)
    file = File.new(File.join(__dir__, '../fixtures/programming_question_template.zip'), 'rb')
    package = Coursemology::Evaluator::Models::ProgrammingEvaluation::Package.new(file)
    evaluation.instance_variable_set(:@package, package)
  end
end

FactoryGirl.define do
  factory :programming_evaluation, class: Coursemology::Evaluator::Models::ProgrammingEvaluation do
    id 1
    language Coursemology::Polyglot::Language::Python::Python2Point7.name
    memory_limit nil
    time_limit nil

    after(:stub) do |evaluation|
      evaluation.define_singleton_method(:save) {}
      ProgrammingEvaluationFactory.define_package(evaluation)
    end

    after(:build) do |evaluation|
      ProgrammingEvaluationFactory.define_package(evaluation)
    end
  end
end
