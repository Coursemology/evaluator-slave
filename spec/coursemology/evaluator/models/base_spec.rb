RSpec.describe Coursemology::Evaluator::Models::Base do
  describe 'class attributes' do
    subject { Coursemology::Evaluator::Models::Base }

    describe '.api_user_email' do
      it { is_expected.to have_attributes(api_user_email: nil) }
    end

    describe '.api_token' do
      it { is_expected.to have_attributes(api_token: nil) }
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
