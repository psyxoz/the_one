lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'the_one/version'

Gem::Specification.new do |spec|
  spec.name          = 'the_one'
  spec.version       = TheOne::VERSION
  spec.authors       = ['Sergey Homenko']
  spec.email         = ['xoma.serg@gmail.com']
  spec.description   = 'Parse the data and upload it into Zion system.'
  spec.summary       = 'Helps Neo to escape from the Matrix!'
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.test_files    = spec.files.grep(%r{^(spec)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'rubyzip', '>= 1.0.0'
  spec.add_dependency 'faraday'
  spec.add_dependency 'multi_json'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'dotenv'
  spec.add_development_dependency 'webmock'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
end
