# coding: utf-8
#
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'omniauth/openid_connect/version'

Gem::Specification.new do |spec|
  spec.name          = "omniauth-openid-connect"
  spec.version       = OmniAuth::OpenIDConnect::VERSION
  spec.authors       = ["John Bohn", "Ilya Shcherbinin", "OpenProject GmbH"]
  spec.email         = ["jjbohn@gmail.com", "m0n9oose@gmail.com", "info@openproject.com"]
  spec.summary       = %q{OpenID Connect Strategy for OmniAuth}
  spec.description   = %q{OpenID Connect Strategy for OmniAuth}
  spec.homepage      = "https://github.com/opf/omniauth-openid-connect"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'omniauth', '~> 2.1.4'
  spec.add_dependency 'openid_connect', '~> 2.2.0'
  spec.add_dependency 'addressable', '~> 2.5'
  spec.add_development_dependency 'bundler', '>= 1.5'
  spec.add_development_dependency 'minitest', '~> 5.1'
  spec.add_development_dependency 'mocha', '~> 2.1.0'
  spec.add_development_dependency 'guard', '~> 2.14'
  spec.add_development_dependency 'guard-minitest', '~> 2.4'
  spec.add_development_dependency 'guard-bundler', '~> 2.1'
  spec.add_development_dependency 'rake', '~> 12.0'
  spec.add_development_dependency 'simplecov', '~> 0.21.2'
  spec.add_development_dependency 'pry', '~> 0.9'
  spec.add_development_dependency 'faker', '~> 3.0'
  spec.add_development_dependency 'net-smtp'
  spec.add_development_dependency 'faraday'
  spec.add_development_dependency 'debug'
  spec.add_development_dependency 'webmock'
end
