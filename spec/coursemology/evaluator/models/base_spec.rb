RSpec.describe Coursemology::Evaluator::Models::Base do
  describe 'class attributes' do
    subject { Coursemology::Evaluator::Models::Base }

    describe '.api_user_email' do
      it { is_expected.to have_attributes(api_user_email: anything) }
    end

    describe '.api_token' do
      it { is_expected.to have_attributes(api_token: anything) }
    end
  end

  describe '.model_key' do
    class self::DummyModel < Coursemology::Evaluator::Models::Base
      model_key :dummy_model

      put :save, '/'
    end
    subject { self.class::DummyModel.new }

    let(:dummy_response) do
      double.tap do |dummy_response|
        allow(dummy_response).to receive(:on_complete)
        allow(dummy_response).to receive(:finished?).and_return(true)
      end
    end

    before do
      expect(self.class::DummyModel).to receive(:fix_put_parameters).
        and_wrap_original do |m, *args|
        @request = args.last
        expect(@request).to receive(:do_request).and_return(dummy_response)

        m.call(*args)
      end
    end

    it 'prepends all request data with the key' do
      subject.lol = true
      subject.save

      expect(@request.post_params).to have_key(:dummy_model)
    end

    context 'when the data is empty' do
      it 'does not prepend the key' do
        subject.save

        expect(@request.post_params).not_to have_key(:dummy_model)
      end
    end
  end

  describe '#adds_authentication' do
    with_mock_client(api_user_email: 'email', api_token: 'token') do
      let(:request) do
        headers = {}
        double.tap do |double|
          expect(double).to receive(:headers).and_return(headers).at_least(:once)
        end
      end
      subject { Coursemology::Evaluator::Models::Base.new.send(:add_authentication, nil, request) }

      it 'adds the X-User-Email header' do
        subject
        expect(request.headers['X-User-Email']).to \
          eq(Coursemology::Evaluator::Models::Base.api_user_email)
      end

      it 'adds the X-User-Token header' do
        subject
        expect(request.headers['X-User-Token']).to \
          eq(Coursemology::Evaluator::Models::Base.api_token)
      end
    end
  end
end
