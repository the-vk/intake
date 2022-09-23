# frozen_string_literal: true

require 'rake'

require_relative './lib/log_sinks/version'

Gem::Specification.new do |spec|
  spec.name                   = 'log_sinks'
  spec.summary                = 'Powerful and extensible logging library'
  spec.version                = LogSinks::VERSION
  spec.homepage               = 'https://github.com/the-vk/log_sinks'
  spec.authors                = ['Andrey Maraev']
  spec.email                  = ['the_vk@thevk.net']
  spec.license                = 'MIT'
  spec.required_ruby_version  = '~> 3.0'
  spec.metadata = {
    'rubygems_mfa_required' => 'true'
  }

  spec.files = FileList['lib/**/*.rb'].to_a

  spec.add_development_dependency 'code-scanning-rubocop'
  spec.add_development_dependency 'debug'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rubocop'
end
