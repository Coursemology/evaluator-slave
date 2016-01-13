FactoryGirl.define do
  factory :programming_evaluation, class: Coursemology::Evaluator::Models::ProgrammingEvaluation do
    id 1
    language 'Polyglot::Language::Python::Python2Point7'
    memory_limit 32
    time_limit 5

    after(:build) do |evaluation|
      package = File.read(File.join(__dir__, '../fixtures/programming_question_template.zip'))
      evaluation.instance_variable_set(:@package, package)
    end
  end
end
