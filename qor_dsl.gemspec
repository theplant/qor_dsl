# -*- encoding: utf-8 -*-
Gem::Specification.new do |gem|
  gem.authors       = ["Jinzhu"]
  gem.email         = ["wosmvp@gmail.com"]
  gem.summary       = %q{DSL made easy!}
  gem.description   = %q{Qor DSL is designed to be as flexible as possible while helping you to create your DSLs.}
  gem.homepage      = "https://github.com/qor/qor_dsl"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "qor_dsl"
  gem.require_paths = ["lib"]
  gem.version       = "0.3.1"
end
