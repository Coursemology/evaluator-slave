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
end
