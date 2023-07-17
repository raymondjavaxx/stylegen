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

  s.add_runtime_dependency 'dry-cli', '~> 0.7.0'
  s.add_runtime_dependency 'dry-inflector', '~> 0.2.1'
  s.add_runtime_dependency 'json_schemer', '~> 1.0.3'

  s.add_development_dependency 'bundler'
  s.add_development_dependency 'minitest', '~> 5.14'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rubocop'
  s.add_development_dependency 'rubocop-minitest'
  s.add_development_dependency 'rubocop-rake'

  s.required_ruby_version = '>= 2.6.0'
  s.metadata['rubygems_mfa_required'] = 'true'
end
