# frozen_string_literal: true
require 'vcr'

Coursemology::Evaluator::Client.initialize('http://localhost:3000', 'test@example.org',
                                           'YOUR_TOKEN_HERE')

VCR.configure do |c|
  c.cassette_library_dir = 'spec/fixtures/vcr/cassettes'
  c.hook_into :faraday
end
