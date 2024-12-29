# frozen_string_literal: true

require_relative 'lib/edr_agent_tester/version'

Gem::Specification.new do |spec|
  spec.name = 'edr_agent_tester'
  spec.version = EdrAgentTester::VERSION
  spec.authors = ['Chris Breen']
  spec.email = ['chris@chrisbreen.dev']

  spec.summary = 'This gem can be installed and used to generate activity for EDR testing.'
  spec.homepage = 'https://github.com/cbween/rcerda'
  spec.required_ruby_version = '>= 3.1.0'
  spec.licenses = nil
  spec.metadata['homepage_uri'] = spec.homepage

  gemspec = File.basename(__FILE__)
  spec.files = Dir["lib/**/*", "bin/edr_agent_tester" "Rakefile", "README.md"]

  spec.executables = %w[edr_agent_tester]
  spec.require_paths = ['lib']

  spec.add_dependency 'etc', '1.4.5'
  spec.add_dependency 'fileutils', '0.7.2'
  spec.add_dependency 'httparty', '0.22.0'
  spec.add_dependency 'semantic_logger', '4.16.0'

  spec.add_development_dependency 'bundler', '~> 2.6.1'
  spec.add_development_dependency 'minitest', '~> 5.8'
  spec.add_development_dependency 'minitest-reporters', '~> 1.1'
  spec.add_development_dependency 'webmock', '~> 3.24.0'
end
