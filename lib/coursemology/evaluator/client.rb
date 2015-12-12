class Coursemology::Evaluator::Client
  def self.initialize(host, api_user_email, api_token)
    Coursemology::Evaluator::Models::Base.base_url = host
    Coursemology::Evaluator::Models::Base.api_user_email = api_user_email
    Coursemology::Evaluator::Models::Base.api_token = api_token
  end

  def initialize
  end

  def run
  end
end
