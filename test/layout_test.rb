require 'minitest/autorun'
require File.join(File.dirname(__FILE__), 'configure')

describe Layout do
  before do
    Layout::Configuration.load('test/layout.rb')
    @root = Layout::Configuration.root
  end

  it "layout config testing" do
    # Find by type
    Layout::Configuration.find(:gadget).length.must_equal 2
    Layout::Configuration.find(:template).length.must_equal 2
    Layout::Configuration.deep_find(:template).length.must_equal 3

    # Find by name
    Layout::Configuration.find(:gadget, 'quick_buy').name.must_equal :quick_buy
    Layout::Configuration.deep_find(:desc, "From Google").value.must_equal "From Google"

    # Find by block
    Layout::Configuration.first(:template) do |n|
      n.options[:since] > "12:50"
    end.value.must_equal 'Hello World2'

    Layout::Configuration.deep_find(:desc) do |n|
      n.parents.include?(Layout::Configuration.find(:action, :google))
    end[0].value.must_equal 'From Google'

    # Inherit
    Layout::Configuration.find(:gadget, :product_link).find(:template)[0].value.must_equal "Hello World"

    # Store any data
    Layout::Configuration.first(:template).data.must_equal ["v1", {:since => "09:00", :to => "12:00"}]

    # Options
    Layout::Configuration.find(:template)[1].options.must_equal({:since => "13:00", :to => "18:00"})

    # Parents
    Layout::Configuration.find(:gadget, :quick_buy).first(:template).parents.count.must_equal 2

    # More is coming... (multi, alias_node)
  end
end
