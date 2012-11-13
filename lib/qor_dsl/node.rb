module Qor
  module Dsl
    class Node
      attr_accessor :name, :config, :parent, :children, :data, :block, :all_nodes, :dummy

      def initialize(name=nil, options={})
        self.name   = name
        self.add_config(options[:config] || Qor::Dsl::Config.new('ROOT', self))
        self.dummy = options[:dummy]
      end

      def node(type, options={}, &blk)
        config.node(type, options, &blk)
      end

      def add_config(config)
        self.config = config
        config.__node = self
      end

      def add_child(child)
        child.parent = self
        children << child
        root.all_nodes ||= []
        root.all_nodes << child
      end


      ## Node Config
      def config_name
        config.__name
      end

      def config_options
        config.__options || {} rescue {}
      end


      ## Node
      def parents
        parent ? [parent, parent.parents].flatten : []
      end

      def children
        @children ||= []
        @children = @children.flatten.compact
        @children
      end

      def root
        parent ? parent.root : self
      end

      def root?
        root == self
      end

      def dummy?
        !!dummy
      end

      def is_node?(node_type=nil, name_str=nil)
        (node_type.nil? || (config_name.to_s == node_type.to_s)) && (name_str.nil? || (name.to_s == name_str.to_s))
      end


      ## Node Data
      def default_value
        config_options[:default_value]
      end

      def value
        ((config.__children.size > 0 || block.nil?) ? (options[:value] || name) : block.call) || default_value
      end

      def default_options
        config_options[:default_options]
      end

      def options
        return data[-1] if data.is_a?(Array) && data[-1].is_a?(Hash)
        return data if data.is_a?(Hash)
        return name if name.is_a?(Hash)
        return default_options || {}
      end

      def default_block
        config_options[:default_block]
      end

      def block
        @block || default_block
      end


      ## Query
      def first(type=nil, name=nil, &block)
        selected_children = find(type, name, &block)
        selected_children.is_a?(Array) ? selected_children[0] : selected_children
      end

      def deep_find(type=nil, name=nil, &block)
        nodes = root.all_nodes
        nodes = nodes.select {|n| n.parents.include?(self) } unless root?
        find(type, name, nodes, &block)
      end

      def find(type=nil, name=nil, nodes=children, &block)
        results = nodes.select do |child|
          child.is_node?(type, name) && (block.nil? ? true : block.call(child))
        end

        results = parent.find(type, name, &block) if results.length == 0 && child_config_options(type)[:inherit]
        process_find_results(results, type)
      end


      def inspect
        obj_options = {
          'name' => name,
          'config' => config_name,
          'parent' => parent && parent.inspect_name,
          'children' => children.map(&:inspect_name),
          'data' => data,
          'block' => block
        }
        Qor::Dsl.inspect_object(self, obj_options)
      end

      protected
      def inspect_name
        "{#{config_name}: #{name || 'nil'}}"
      end

      private
      def process_find_results(results, type)
        if results.length == 0 &&
          %w(default_options default_value default_block).any? {|x| child_config_options(type)[x.to_sym] }
          results = [Node.new(nil, :config => child_config(type), :dummy => true)]
        end
        results
      end

      def child_config(type)
        config.__children[type] || nil
      end

      def child_config_options(type)
        child_config(type).__options || {} rescue {}
      end
    end
  end
end
