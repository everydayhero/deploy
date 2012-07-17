# -*- encoding: utf-8 -*-
require File.expand_path('../lib/super_mega_ultra_capistrano_extensions/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Tim Cooper"]
  gem.email         = ["coop@latrobest.com"]
  gem.description   = "Common deployment options"
  gem.summary       = "Common deployment options"
  gem.homepage      = "http://github.com/everydayhero/super_mega_ultra_capistrano_extensions"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test)/})
  gem.name          = "super_mega_ultra_capistrano_extensions"
  gem.require_paths = ["lib"]
  gem.version       = SuperMegaUltraCapistranoExtensions::VERSION
  gem.add_dependency 'capistrano', '~> 2.12.0'
end
