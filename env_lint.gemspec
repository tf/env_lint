# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'env_lint/version'

Gem::Specification.new do |spec|
  spec.name          = 'env_lint'
  spec.version       = EnvLint::VERSION
  spec.authors       = ['Tim Fischbach']
  spec.email         = ['mail@timfischbach.de']
  spec.summary       = 'Lint the environment according by .env.example'
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'formatador'
  spec.add_runtime_dependency 'capistrano', '~> 2.9'

  spec.add_development_dependency 'rspec', '3.0.0.beta1'
  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
end
