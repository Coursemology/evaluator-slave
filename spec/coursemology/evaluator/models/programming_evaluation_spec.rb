require 'spec_helper'

RSpec.describe Coursemology::Evaluator::Models::ProgrammingEvaluation do
  describe '.allocate' do
    let(:evaluation) { Coursemology::Evaluator::Models::ProgrammingEvaluation.allocate.first }
    it 'obtains an unallocated evaluation' do
      VCR.use_cassette 'programming_evaluation/allocate' do
        expect(evaluation.id).not_to be_nil
      end
    end
  end

  describe '.find' do
    let(:find_id) { 2 }
    let(:evaluation) { Coursemology::Evaluator::Models::ProgrammingEvaluation.find(find_id) }

    it 'obtains the requested evaluation' do
      VCR.use_cassette 'programming_evaluation/find' do
        expect(evaluation.id).to eq(find_id)
      end
    end
  end
end
