#!/usr/bin/env ruby

require File.expand_path(File.join(File.dirname(__FILE__), '../lib/qor_dsl'))

class Gemfile
  include Qor::Dsl
  default_configs [ENV['BUNDLE_GEMFILE'], File.join(File.dirname(__FILE__), 'Gemfile')]

  node :source, :default_value => 'http://rubygems.org'
  node :gem

  node :group do
    node :gem
  end

  node :example do
    node :gem, :inherit => true
  end
end

# Default Value
Gemfile.first(:source)

# Methods for query
Gemfile.first(:gem)
Gemfile.first(:gem, 'unicorn')

Gemfile.find(:gem)
Gemfile.find(:gem, 'rails')
Gemfile.find(:gem) do |n|
  !!n.options[:git].nil?
end

Gemfile.first(:group, 'development').find(:gem)

Gemfile.deep_find(:gem)
Gemfile.deep_find(:gem) do |n|
  # Find all gems used in development environment
  parent = n.parent
  parent.root? || parent.is_node?(:group, :development)
end

# Methods for node
node = Gemfile.find(:gem, 'devise')
node.name
node.value
node.options
node.data
node.config
node.parent
node.parents
node.root
node.root?
