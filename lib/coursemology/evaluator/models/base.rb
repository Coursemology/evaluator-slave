class Coursemology::Evaluator::Models::Base < ActiveRestClient::Base
  class << self
    attr_accessor :api_user_email
    attr_accessor :api_token
  end

  before_request :add_authentication

  private

  # Adds the authentication email and token to the request.
  def add_authentication(_, request)
    request.headers['X-User-Email'] = self.class.api_user_email
    request.headers['X-User-Token'] = self.class.api_token
  end
end
