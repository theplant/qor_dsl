Qor Dsl - DSL made easy!
=======

[![Build Status](https://secure.travis-ci.org/qor/qor_dsl.png?branch=master)][travis]
[![Code Climate](https://codeclimate.com/badge.png)][codeclimate]
[travis]: http://travis-ci.org/qor/qor_dsl
[codeclimate]: https://codeclimate.com/github/qor/qor_dsl

## Description

    Why DSL? Easy to read, Easy to write, Easy to maintain!
    Why Qor DSL? Make it even easier! Write your DSLs in 10 minutes!

## Usage

1, Adding it as dependency to your Gemspec or Gemfile:

    # your_awesome_gem.gemspec
    Gem::Specification.new do |gem|
      gem.add_dependency "qor_dsl"
    end

    # Gemfile
    gem "qor_dsl"

2, Defining DSL (Sample configuration support DSLs like [Gemfile](http://gembundler.com))

    # gemfile.rb
    class Gemfile
      include Qor::Dsl
      default_configs [ENV['BUNDLE_GEMFILE'], 'Gemfile']

      node :source
      node :gem

      node :group do
        node :gem
      end
    end

3, Defining config (Sample Gemfile file used for above config)

    # Using default config file `Gemfile`
    source 'http://rubygems.org'

    gem 'rails', '3.2.8'
    gem 'unicorn'
    gem 'devise', :git => "git://github.com/jinzhu/devise.git", :ref => "b94ee9da98b16e4c8fbdc91af8605669d01b17e6"

    group :development do
      gem 'pry-rails'
    end

    group :test do
      gem 'rspec'
    end

    # Or using code block
    Gemfile.load do
      source 'http://rubygems.org'

      gem 'rails', '3.2.8'
      gem 'unicorn'
    end

4, Querying config (Please checkout the source code and play with examples under the `example` directory for more details)

    # Find by type
    Gemfile.find(:gem)

    # Find by type and name also chain query
    Gemfile.find(:group, 'development').find(:gem)

    # Get all gems
    Gemfile.deep_find(:gem)

    # Find by block
    Gemfile.deep_find(:gem) do |n|
      # Find all gems used in development environment
      parent = n.parent
      parent.root? || ((parent.config_name == :group) && parent.name == :development)
    end

    # Qor DSL is designed to be as flexible as possible while helping you to create your DSLs.
    # Please check source code for all possibilities!

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
