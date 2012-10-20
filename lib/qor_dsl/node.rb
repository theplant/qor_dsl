module Qor
  module Dsl
    class Node
      attr_accessor :name, :config, :parent, :children, :data, :options, :block, :all_nodes

      def initialize(name=nil, options={})
        self.name   = name
        self.add_config(options[:config] || Qor::Dsl::Config.new('ROOT', self))
      end

      def config_name
        config.__name
      end

      def inspect_name
        "{#{config_name}: #{name || 'nil'}}"
      end

      def root
        parent ? parent.root : self
      end

      def parents
        parent ? [parent, parent.parents].flatten : []
      end

      def options
        return @options if @options.is_a?(Hash)
        return data[-1] if data.is_a?(Array) && data[-1].is_a?(Hash)
        return data if data.is_a?(Hash)
        {}
      end

      def value
        block.nil? ? (options[:value] || name) : block.call
      end

      def add_config(config)
        self.config = config
        config.__node = self
      end

      def node(type, options={}, &blk)
        config.node(type, options, &blk)
      end

      def children
        @children ||= []
        @children = @children.flatten.compact
        @children
      end

      def config_options_for_child(type)
        config.__children[type].__options || {} rescue {}
      end

      def add_child(child)
        child.parent = self
        children << child
        root.all_nodes ||= []
        root.all_nodes << child
      end

      def deep_find(type=nil, name=nil, &block)
        nodes = root.all_nodes
        nodes = nodes.select {|n| n.parents.include?(self) } if root != self
        find(type, name, nodes, &block)
      end

      def find(type=nil, name=nil, nodes=children, &block)
        selected_children = nodes.select do |child|
          (type.nil? ? true : (child.config_name.to_s == type.to_s)) &&
            (name.nil? ? true : (child.name.to_s == name.to_s)) &&
            (block.nil? ? true : block.call(child))
        end

        return selected_children[0] if !name.nil? && selected_children.length == 1
        return parent.find(type, name) if (selected_children.length == 0) && config_options_for_child(type)[:inherit]
        selected_children
      end

      def first(type=nil, name=nil, &block)
        selected_children = find(type, name, &block)
        selected_children.is_a?(Array) ? selected_children[0] : selected_children
      end

      def to_s
        result = [
          ['name',     name],
          ['parent',   parent && parent.inspect_name],
          ['config',   config_name],
          ['children', children.map(&:inspect_name)],
          ['data',     data],
          ['block',    block]
        ].inject({}) do |s, value|
          s[value[0]] = value[1] if value[1] && value[1].to_s.length > 0
          s
        end.inspect

        "#<Qor::Dsl::Node:0x#{object_id.to_s(16)} #{result}>"
      end
    end
  end
end
