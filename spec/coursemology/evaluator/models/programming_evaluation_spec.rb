require 'spec_helper'

RSpec.describe Coursemology::Evaluator::Models::ProgrammingEvaluation do
  subject { build(:programming_evaluation) }

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

  describe '#language' do
    it 'returns an instance of Coursemology::Polyglot::Language' do
      expect(subject.language).to be_a(Coursemology::Polyglot::Language)
    end
  end

  describe '#language=' do
    context 'when nil is given' do
      it 'unsets the language' do
        subject.language = nil
        expect(subject.language).to be_nil
      end
    end

    context 'when a language name is given' do
      it 'sets the language' do
        subject.language = Coursemology::Polyglot::Language::Python::Python2Point7.name
        expect(subject.language).to be_a(Coursemology::Polyglot::Language::Python::Python2Point7)
      end
    end

    context 'when a language instance is given' do
      it 'sets the language' do
        subject.language = Coursemology::Polyglot::Language::Python::Python2Point7.new
        expect(subject.language).to be_a(Coursemology::Polyglot::Language::Python::Python2Point7)
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

  describe '#evaluate' do
    it 'sets the stdout attribute' do
      expect { subject.evaluate }.to change { subject.stdout }
    end

    it 'sets the stderr attribute' do
      expect { subject.evaluate }.to change { subject.stderr }
    end

    it 'sets the test_report attribute' do
      pending
      expect { subject.evaluate }.to change { subject.test_report }
    end
  end
end
