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
      allow(subject).to receive(:sleep) { sleep(0.1.seconds) }

      Thread.new { subject.instance_variable_set(:@terminate, true) }
      subject.run
    end
  end

  describe '#allocate_evaluations' do
    context 'when an evaluation is provided' do
      let(:dummy_evaluation) { build_stubbed(:programming_evaluation) }
      before do
        expect(Coursemology::Evaluator::Models::ProgrammingEvaluation).to \
          receive(:allocate).and_return([dummy_evaluation])
      end

      it 'calls #on_evaluation with the evaluation' do
        expect(subject).to receive(:on_evaluation).with(dummy_evaluation)
        subject.send(:allocate_evaluations)
      end

      it 'instruments the allocation request' do
        expect { subject.send(:allocate_evaluations) }.to \
          instrument_notification('allocate.client.evaluator.coursemology')
      end
    end

    context 'when allocation fails' do
      context 'when allocation fails due to a HTTP Unauthorized' do
        with_mock_client(host: 'http://localhost:3000', api_user_email: '', api_token: '') do
          it 'publishes the allocate_fail event' do
            expect do
              VCR.use_cassette('client/allocation_unauthorized') do
                subject.send(:allocate_evaluations)
              end
            end.to publish_notification('allocate_fail.client.evaluator.coursemology')
          end
        end
      end
    end
  end

  describe '#on_evaluation' do
    let(:dummy_evaluation) do
      build_stubbed(:programming_evaluation).tap do |dummy_evaluation|
        expect(dummy_evaluation).to receive(:evaluate)
      end
    end

    it 'evaluates the evaluation' do
      subject.send(:on_evaluation, dummy_evaluation)
    end

    it 'instruments the evaluation' do
      expect { subject.send(:on_evaluation, dummy_evaluation) }.to \
        instrument_notification('evaluate.client.evaluator.coursemology')
    end

    it 'instruments the save' do
      expect { subject.send(:on_evaluation, dummy_evaluation) }.to \
        instrument_notification('save.client.evaluator.coursemology')
    end
  end

  describe '#on_sig_term' do
    it 'terminates the loop' do
      expect(subject).to receive(:allocate_evaluations).at_least(:once)
      allow(subject).to receive(:sleep) { sleep(0.1.seconds) }

      Thread.new { subject.send(:on_sig_term) }
      subject.run
    end
  end
end
