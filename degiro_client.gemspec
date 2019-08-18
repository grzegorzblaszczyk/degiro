lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'degiro_client/version'

Gem::Specification.new do |spec|
  spec.name          = 'degiro_client'
  spec.homepage      = 'https://github.com/grzegorzblaszczyk/degiro'
  spec.licenses      = ['MIT']
  spec.version       = DeGiro::VERSION
  spec.description   = 'Ruby Client for the unofficial DeGiro API - working version with all basic methods'
  spec.summary       = 'Ruby Client for the unofficial DeGiro API'
  spec.authors       = ['Grzegorz Błaszczyk', 'Tom Van Eyck']
  spec.email         = ['grzegorz.blaszczyk@gmail.com', 'tomvaneyck@gmail.com']

  spec.files         = Dir.glob('lib/**/*.rb')
  spec.require_paths = ['lib']

  spec.add_dependency 'faraday', '~> 0.13.1'
  spec.add_dependency 'faraday-cookie_jar', '~> 0.0.6'
  spec.add_dependency 'faraday-detailed_logger', '~> 2.1.3'

  spec.add_development_dependency 'pry', '~> 0.12.2'
  spec.add_development_dependency 'rubocop', '~> 0.51.0'
end
