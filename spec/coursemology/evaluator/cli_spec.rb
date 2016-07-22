# frozen_string_literal: true
RSpec.describe Coursemology::Evaluator::CLI do
  let(:host) { 'http://localhost:3000' }
  let!(:original_api_token) { Coursemology::Evaluator::Models::Base.api_token }
  let(:api_token) { 'abcd' }
  let(:api_user_email) { 'test@example.org' }
  let(:poll_interval) { '20S' }
  let(:cache_expiry) { '2D' }
  let(:argv) do
    ["--host=#{host}", "--api-token=#{api_token}", "--api-user-email=#{api_user_email}",
     '--one-shot', "--interval=#{poll_interval}", "--expiry=#{cache_expiry}"]
  end
  let(:argv_missing) do
    ["--host=#{host}", "--api-token=#{api_token}", "--api-user-email=#{api_user_email}",
     '--one-shot']
  end

  describe Coursemology::Evaluator::CLI::Options do
    it 'checks Options attributes' do
      expect(subject).to have_attributes(host: nil, api_token: nil, api_user_email: nil,
                                         poll_interval: nil, cache_expiry: nil)
    end
  end

  with_mock_client do
    describe '.start' do
      subject { Coursemology::Evaluator::CLI }
      it 'calls #start' do
        expect(subject).to receive_message_chain(:new, :start)
        subject.start(argv)
      end
    end

    describe '#start' do
      subject { Coursemology::Evaluator::CLI.new }
      it 'calls #run' do
        expect(subject).to receive(:run)
        subject.start(argv)
      end
    end

    describe '#run' do
      let(:api_token) { original_api_token }
      subject { Coursemology::Evaluator::CLI.new.run(argv) }

      it 'creates a client' do
        expect(Coursemology::Evaluator::Client).to receive(:new).and_call_original
        VCR.use_cassette('client/no_pending_evaluations') do
          subject
        end
      end

      it 'runs the client' do
        expect(Coursemology::Evaluator::Client).to receive_message_chain(:new, :run)
        VCR.use_cassette('client/no_pending_evaluations') do
          subject
        end
      end

      it 'evaluates the package' do
        VCR.use_cassette('client/pending_evaluation') do
          subject
        end
      end
    end
  end

  describe '#optparse!' do
    subject { Coursemology::Evaluator::CLI.new.send(:optparse!, argv) }

    it 'parses --host' do
      expect(subject.host).to eq(host)
    end

    it 'parses --api-token' do
      expect(subject.api_token).to eq(api_token)
    end

    it 'parses api-user-email' do
      expect(subject.api_user_email).to eq(api_user_email)
    end

    it 'parses poll-interval' do
      expect(subject.poll_interval).to eq(poll_interval)
    end

    it 'parses cache-expiry' do
      expect(subject.cache_expiry).to eq(cache_expiry)
    end
  end

  describe '#optparse! defaults' do
    subject { Coursemology::Evaluator::CLI.new.send(:optparse!, argv_missing) }

    it 'sets default value for poll_interval' do
      expect(subject.poll_interval).to eq('10S')
    end

    it 'sets default value for cache_expiry' do
      expect(subject.cache_expiry).to eq('1D')
    end
  end
end
