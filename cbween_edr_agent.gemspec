# frozen_string_literal: true

require_relative "lib/cbween_edr_agent/version"

Gem::Specification.new do |spec|
  spec.name = "cbween_edr_agent"
  spec.version = CbweenEdrAgent::VERSION
  spec.authors = ["Chris Breen"]
  spec.email = ["chris@chrisbreen.dev"]

  spec.summary = "This gem can be installed and used to generate activity for EDR testing."
  spec.homepage = "https://github.com/cbween/"
  spec.required_ruby_version = ">= 3.1.0"

  spec.metadata["homepage_uri"] = spec.homepage
  # spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git appveyor Gemfile])
    end
  end
  # spec.bindir = "exe"
  spec.executables = %w[cbween_edr_agent]
  spec.require_paths = ["lib"]

  spec.add_dependency "semantic_logger", "4.16.0"
  spec.add_dependency "fileutils", "0.7.2"
  spec.add_dependency "httparty", "0.22.0"
  spec.add_dependency "etc", "1.4.5"

  spec.add_development_dependency 'bundler', "~> 2.6.1"
  spec.add_development_dependency "minitest", "~> 5.8"
  spec.add_development_dependency "minitest-reporters", "~> 1.1"
  spec.add_development_dependency "webmock", "~> 3.24.0"
end
