# -*- encoding: utf-8 -*-
require File.expand_path('../lib/stormpocalypse/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Cameron Cundiff"]
  gem.email         = ["ckundo@gmail.com"]
  gem.description   = %q{NOAA National Weather Service alerts.}
  gem.summary       = %q{A wrapper for the NWS severe weather alert feed}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "stormpocalypse"
  gem.require_paths = ["lib"]
  gem.version       = Stormpocalypse::VERSION
  
  gem.add_dependency('httparty', '~> 0.8.1')
  
  gem.add_development_dependency('rspec', '~> 2.9.0')
  gem.add_development_dependency('webmock', '~> 1.8.3')
end
