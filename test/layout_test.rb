require 'minitest/autorun'
require File.join(File.dirname(__FILE__), 'configure')

describe Layout do
  before do
    Layout::Configuration.load('test/layout.rb')
    @root = Layout::Configuration.root
  end

  it "layout config testing" do
    # Simple query
    Layout::Configuration.find(:gadget).length.must_equal 2

    # Find by name
    Layout::Configuration.find(:gadget, 'quick_buy').name.must_equal :quick_buy

    # Inherit
    Layout::Configuration.find(:gadget, :product_link).find(:template)[0].value.must_equal "Hello World"

    # Store any data
    Layout::Configuration.first(:template).data.must_equal ["v1", {:since=>"9am", :to=>"12am"}]

    # Options
    Layout::Configuration.find(:template)[1].options.must_equal({:since => "1pm", :to => "6am"})

    # More is coming... (multi, alias_node)
  end
end
