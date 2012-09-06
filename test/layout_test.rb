require 'minitest/autorun'
require File.join(File.dirname(__FILE__), 'configure')

describe Layout do
  before do
    Layout::Configuration.load('test/dsl/layout.rb')
    @root = Layout::Configuration.root
  end

  it "has four children" do
    # test query
    Layout::Configuration.find(:gadget).length.must_equal 2
    # test normal find
    Layout::Configuration.find(:gadget, 'quick_buy').name.must_equal :quick_buy
    # test Inherit
    Layout::Configuration.find(:gadget, :product_link).find(:template).value.must_equal "Hello World"

    # More is coming... (test multi, alias_node)
  end
end
