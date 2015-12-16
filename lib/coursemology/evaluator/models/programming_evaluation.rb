class Coursemology::Evaluator::Models::ProgrammingEvaluation < Coursemology::Evaluator::Models::Base
  get :find, 'courses/assessment/programming_evaluations/:id'
  post :allocate, 'courses/assessment/programming_evaluations/allocate'

  # Obtains the package as a string.
  #
  # @return [String]
  def package
    plain_request('courses/assessment/programming_evaluations/:id/package', id: id)
  end

  private

  # Performs a plain request.
  #
  # @param [String] url The URL to request.
  # @param [Hash] params The parameter to be part of the request.
  # @return [String] The response body.
  def plain_request(url, params = {})
    request = ActiveRestClient::Request.new({ url: url, method: :get, options: { plain: true } },
                                            self.class)
    request.call(params)
  end
end
