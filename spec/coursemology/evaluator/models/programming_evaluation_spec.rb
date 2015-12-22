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

  describe '#package' do
    let(:evaluation) { Coursemology::Evaluator::Models::ProgrammingEvaluation.find(3) }

    it 'obtains the requested package' do
      VCR.use_cassette 'programming_evaluation/package' do
        expect(evaluation.package).to \
          be_a(Coursemology::Evaluator::Models::ProgrammingEvaluation::Package)
      end
    end

    it 'memoises its result' do
      VCR.use_cassette 'programming_evaluation/package' do
        expect(evaluation).to receive(:plain_request).and_call_original
        evaluation.package
        evaluation.package
      end
    end
  end
end
