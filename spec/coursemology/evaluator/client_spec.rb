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
end
