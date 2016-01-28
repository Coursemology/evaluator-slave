# frozen_string_literal: true
class Coursemology::Evaluator::Models::Base < Flexirest::Base
  class << self
    attr_accessor :api_user_email
    attr_accessor :api_token

    def initialize
      Flexirest::Base.perform_caching = false
      default_config = Flexirest::Base.faraday_config
      Flexirest::Base.faraday_config do |faraday|
        # +follow_redirects+ must be added before declaring the adapter. See faraday_middleware#32,
        # last comment.
        faraday.response :follow_redirects

        default_config.call(faraday)
      end
    end
  end

  verbose!
  before_request :add_authentication

  # Sets the key of the model. This is the key that all attributes are nested under, the same as
  # the +require+ directive in the controller of the web application.
  #
  # @param [String] key The key to prefix all attributes with.
  def self.model_key(key)
    before_request do |name, param|
      fix_put_parameters(key, name, param) if [:post, :patch, :put].include?(param.method[:method])
    end
  end
  private_class_method :model_key

  # Fixes the request parameters when executing a POST, PATCH or PUT.
  #
  # @param [String] key The key to prefix all attributes with.
  # @param [Request] param The request parameter to prepend the key with.
  def self.fix_put_parameters(key, _, param)
    param.post_params = { key => param.post_params } unless param.post_params.empty?
  end
  private_class_method :fix_put_parameters

  private

  # Adds the authentication email and token to the request.
  def add_authentication(_, request)
    request.headers['X-User-Email'] = self.class.api_user_email
    request.headers['X-User-Token'] = self.class.api_token
  end
end
