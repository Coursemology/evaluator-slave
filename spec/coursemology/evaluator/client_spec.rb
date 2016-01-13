RSpec.describe Coursemology::Evaluator::Client do
  with_mock_client do
    describe '.initialize' do
      let(:base_url) { 'http://localhost:3000' }
      let(:api_token) { 'abcd' }
      let(:api_user_email) { 'test@example.org' }

      subject { Coursemology::Evaluator::Client }

      it 'sets the API parameters' do
        subject.initialize(base_url, api_user_email, api_token)
        expect(Coursemology::Evaluator::Models::Base.base_url).to eq(base_url)
        expect(Coursemology::Evaluator::Models::Base.api_user_email).to eq(api_user_email)
        expect(Coursemology::Evaluator::Models::Base.api_token).to eq(api_token)
      end
    end
  end

  describe '#run' do
    it 'loops until @terminate is set' do
      expect(subject).to receive(:allocate_evaluations).at_least(:once)
      allow(subject).to receive(:sleep) do
        sleep(0.1.seconds)
      end

      Thread.new { subject.instance_variable_set(:@terminate, true) }
      subject.run
    end
  end

  describe '#allocate_evaluations' do
    context 'when an evaluation is provided' do
      let(:dummy_evaluation) { build(:programming_evaluation) }
      before do
        expect(Coursemology::Evaluator::Models::ProgrammingEvaluation).to \
          receive(:allocate).and_return([dummy_evaluation])
      end

      it 'calls #on_allocate with the evaluation' do
        expect(subject).to receive(:on_allocate).with([dummy_evaluation]).and_call_original
        subject.send(:allocate_evaluations)
      end
    end
  end

  describe '#on_sig_term' do
    it 'terminates the loop' do
      expect(subject).to receive(:allocate_evaluations).at_least(:once)
      allow(subject).to receive(:sleep) do
        sleep(0.1.seconds)
      end
      Thread.new { subject.send(:on_sig_term) }
      subject.run
    end
  end
end
