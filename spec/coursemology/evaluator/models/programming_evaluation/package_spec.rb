require 'spec_helper'

RSpec.describe Coursemology::Evaluator::Models::ProgrammingEvaluation::Package do
  around(:each) do |example|
    File.open(Pathname.new(__dir__).join('../../../..',
                                         'fixtures/programming_question_template.zip')) do |file|
      define_singleton_method(:file) { file }
      example.call
    end
  end

  let(:package) { Coursemology::Evaluator::Models::ProgrammingEvaluation::Package.new(file) }
  describe '#initialize' do
    it 'accepts an IO object' do
      package
    end
  end

  describe '#stream' do
    it 'returns the provided IO object' do
      expect(package.stream).to be(file)
    end
  end
end
