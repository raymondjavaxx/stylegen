# frozen_string_literal: true

require './lib/stylegen/version'

Gem::Specification.new do |s|
  s.name = 'stylegen'
  s.version = Stylegen::VERSION
  s.platform = Gem::Platform::RUBY
  s.authors = ['Ramon Torres']
  s.email = ['raymondjavaxx@gmail.com']
  s.homepage = 'https://github.com/raymondjavaxx/stylegen'
  s.description = s.summary = 'Tool for generating styling code for iOS apps'
  s.files = Dir['README.md', 'CHANGELOG.md', 'LICENSE', 'bin/stylegen', 'lib/**/*.rb', 'lib/**/*.yaml', 'lib/**/*.json']
  s.executables = ['stylegen']
  s.require_paths = ['lib']
  s.license = 'MIT'

  s.add_runtime_dependency 'dry-cli', '~> 1.0.0'
  s.add_runtime_dependency 'dry-inflector', '~> 1.0.0'
  s.add_runtime_dependency 'json_schemer', '~> 1.0.3'

  s.required_ruby_version = '>= 2.7.0'
  s.metadata['rubygems_mfa_required'] = 'true'
end
