require 'minitest/autorun'
require File.join(File.dirname(__FILE__), 'configure')

describe Layout do
  def many_times
    threads = 100.times.map do |t|
      Thread.new do
        yield
      end
    end
    threads.map(&:join)
  end

  it "layout config testing" do
    many_times do
      Layout::Configuration.load('test/layout.rb', :force => true)
      # Find by type
      Layout::Configuration.find(:gadget).length.must_equal 2
      Layout::Configuration.find(:template).length.must_equal 2
      Layout::Configuration.deep_find(:template).length.must_equal 3
      # :settings, :meta, :meta, :meta, :meta, :context, :template
      Layout::Configuration.find(:gadget, :quick_buy).deep_find().length.must_equal 7

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

      # Value for node
      Layout::Configuration.find(:gadget, :quick_buy).value.must_equal :quick_buy

      Layout::Configuration.find(:gadget, :quick_buy).value.must_equal :quick_buy
    end
    # More is coming... (multi, alias_node)
  end

  it "test node helper" do
    many_times do
      Layout::Configuration.load('test/layout.rb', :force => true)
      node = Layout::Configuration.find(:gadget, :quick_buy)
      node.is_node?(:gadget).must_equal true
      node.is_node?(:gadget, 'quick_buy').must_equal true
      node.is_node?(:template).must_equal false
      node.is_node?('gadget').must_equal true
      node.is_node?.must_equal true
    end
  end

  it "force load" do
    many_times do
      Layout::Configuration.load('test/layout.rb', :force => true)
      root = Layout::Configuration.root
      root.find(:gadget).length.must_equal 2
      old_object_ids = root.find(:gadget).map(&:object_id).sort

      Layout::Configuration.load('test/layout.rb')
      root.find(:gadget).map(&:object_id).sort.must_equal old_object_ids

      Layout::Configuration.load('test/layout.rb', :force => true)
      new_root = Layout::Configuration.root

      new_root.find(:gadget).length.must_equal 2
      root.find(:gadget).map(&:object_id).sort.must_equal old_object_ids
      new_root.find(:gadget).map(&:object_id).sort.wont_be_same_as old_object_ids
    end
  end

  it "load config from block" do
    many_times do
      Layout::Configuration.load(nil, :force => true) do
        template "new" do
          "New Template"
        end
      end

      Layout::Configuration.find(:template).count.must_equal 1
      Layout::Configuration.first(:template).value.must_equal "New Template"
    end
  end

  it "should raise exception if configuration not found" do
    many_times do
      lambda { Layout::Configuration.load("non_existing_file.rb", :force => true) }.must_raise Qor::Dsl::ConfigurationNotFound
    end
  end
end
