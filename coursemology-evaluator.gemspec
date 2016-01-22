# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'coursemology/evaluator/version'

Gem::Specification.new do |spec|
  spec.name          = 'coursemology-evaluator'
  spec.version       = Coursemology::Evaluator::VERSION
  spec.authors       = ['Joel Low']
  spec.email         = ['joel@joelsplace.sg']
  spec.license       = 'MIT'

  spec.summary       = 'Coursemology programming package evaluator'
  spec.description   = 'Sets up a consistent environment for evaluating programming packages.'
  spec.homepage      = 'http://coursemology.org'
  spec.files         = `git ls-files -z`.split("\x0").
                       reject { |f| f.match(/^(test|spec|features)\//) }
  spec.executables   = spec.files.grep(/^bin\//) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'factory_girl'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'coveralls'
  spec.add_development_dependency 'codeclimate-test-reporter'
  spec.add_development_dependency 'vcr'

  spec.add_dependency 'activesupport', '~> 4.2.0'
  spec.add_dependency 'flexirest', '~> 1.2'
  spec.add_dependency 'faraday_middleware'

  spec.add_dependency 'coursemology-polyglot', '>= 0.0.3'
  spec.add_dependency 'docker-api', '>= 1.2.5'
  spec.add_dependency 'rubyzip'
end
