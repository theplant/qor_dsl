# -*- encoding: utf-8 -*-
Gem::Specification.new do |gem|
  gem.authors       = ["Jinzhu"]
  gem.email         = ["wosmvp@gmail.com"]
  gem.description   = %q{Qor DSL}
  gem.summary       = %q{Qor DSL}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "qor_dsl"
  gem.require_paths = ["lib"]
  gem.version       = "0.0.3"
end
