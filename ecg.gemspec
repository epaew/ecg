# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ecg/version'

Gem::Specification.new do |spec|
  spec.name                  = 'ecg'
  spec.version               = ECG::VERSION
  spec.required_ruby_version = '>= 2.5.0'

  spec.authors     = ['epaew']
  spec.email       = ['epaew.333@gmail.com']
  spec.summary     =
    'ecg is an ERB(eRuby) based, simple and powerful configration file generator for general purpose.'
  spec.description = spec.summary
  spec.homepage    = 'https://epaew.github.io/ecg'
  spec.license     = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = 'https://rubygems.org'
  else
    raise 'RubyGems 2.0 or newer is required to protect against public gem pushes.'
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files bin/ecg lib *.md LICENSE`.split("\n")
  end
  spec.bindir        = 'bin'
  spec.executables   = ['ecg'] # written in ruby only.
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'simplecov', '< 0.22'
  spec.add_development_dependency 'simplecov-console'
  spec.add_development_dependency 'test-unit', '~> 3.2'
  spec.add_development_dependency 'test-unit-rr', '~> 1.0'
end
