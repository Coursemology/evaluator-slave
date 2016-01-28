# frozen_string_literal: true
class Coursemology::Evaluator::Client
  module TestGroupHelperMethods
    def self.client_options_description(host, api_user_email, api_token)
      result = []
      result << "host: #{host}" if host
      result << "api_user_email: #{api_user_email}" if api_user_email
      result << "api_token: #{api_token}" if api_token

      result
    end

    def self.mock_client(host, api_user_email, api_token)
      proc do
        base_model = Coursemology::Evaluator::Models::Base
        instance_exec(base_model, :base_url, host,
                      &TestGroupHelperMethods.instance_method(:mock_property).bind(self))
        instance_exec(base_model, :api_user_email, api_user_email,
                      &TestGroupHelperMethods.instance_method(:mock_property).bind(self))
        instance_exec(base_model, :api_token, api_token,
                      &TestGroupHelperMethods.instance_method(:mock_property).bind(self))
      end
    end

    def mock_property(object, property, value)
      allow(object).to receive(property) do
        value
      end
      allow(object).to receive("#{property}=".to_s) do |new_value|
        value = new_value
      end
    end
  end

  module TestGroupHelpers
    def with_mock_client(host: nil, api_user_email: nil, api_token: nil, &block)
      client_description = TestGroupHelperMethods.
                           client_options_description(host, api_user_email, api_token).to_sentence

      context "with client: #{client_description}" do
        before(:each, &TestGroupHelperMethods.mock_client(host, api_user_email, api_token))

        module_eval(&block)
      end
    end
  end
end

RSpec.configure do |config|
  config.extend Coursemology::Evaluator::Client::TestGroupHelpers
end
