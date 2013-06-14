# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'trebuchet/version'

Gem::Specification.new do |gem|
  gem.name          = "trebuchet"
  gem.version       = Trebuchet::VERSION
  gem.authors       = ["Duncan Bayne"]
  gem.email         = ["dhgbayne@gmail.com"]
  gem.description   = %q{A somewhat hacked-up library to allow avant-garde-ci to deploy to Amazon Elastic Beanstalk.}
  gem.summary       = %q{A somewhat hacked-up library to allow avant-garde-ci to deploy to Amazon Elastic Beanstalk.}
  gem.homepage      = "https://www.github.com/duncan-bayne/trebuchet"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency 'rake'
  gem.add_dependency 'aws-sdk'
  gem.add_dependency 'rubyzip'
  gem.add_dependency 'grit'

  gem.add_development_dependency 'pry'
  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'rspec-spies'
  gem.add_development_dependency 'roodi'
end


