FactoryGirl.define do
  factory :programming_evaluation, class: Coursemology::Evaluator::Models::ProgrammingEvaluation do
    id 1
    language Coursemology::Polyglot::Language::Python::Python2Point7.name
    memory_limit 32
    time_limit 5

    after(:build) do |evaluation|
      file = File.new(File.join(__dir__, '../fixtures/programming_question_template.zip'), 'rb')
      package = Coursemology::Evaluator::Models::ProgrammingEvaluation::Package.new(file)
      evaluation.instance_variable_set(:@package, package)
    end
  end
end
