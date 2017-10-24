# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'query_empire/version'

Gem::Specification.new do |spec|
  spec.name          = 'query_empire'
  spec.version       = QueryEmpire::VERSION
  spec.authors       = ['Marcin Skłodowski', 'Fred Thompson']
  spec.email         = %w(marcin.sklodowski@buildempire.co.uk fred.thompson@buildempire.co.uk)

  spec.summary       = 'Advanced query builder'
  spec.description   = 'Filter ActiveRecord results with search params easily'
  spec.homepage      = 'https://buildempire.co.uk'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.15'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
end
