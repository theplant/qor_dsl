module Qor
  module Dsl
    class Node
      attr_accessor :name, :config, :parent, :children, :options, :block

      def initialize(name=nil, options={})
        self.name   = name
        self.add_config(options[:config] || Qor::Dsl::Config.new('ROOT', self))
      end

      def inspect_name
        "{#{config.__name}: #{name || 'nil'}}"
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
        config.__children[type].__options || {}
      end

      def add_child(child)
        child.parent = self
        children << child
      end

      def find(type=nil, name=nil)
        selected_children = children.select do |child|
          (type.nil? ? true : (child.config.__name.to_s == type.to_s)) &&
            (name.nil? ? true : (child.name.to_s == name.to_s))
        end

        return selected_children[0] if !name.nil? && selected_children.length == 1
        return parent.find(type, name) if (selected_children.length == 0) && config_options_for_child(type)[:inherit]
        selected_children
      end

      def first(type=nil, name=nil)
        selected_children = find(type, name)
        selected_children.is_a?(Array) ? selected_children[0] : selected_children
      end

      def value
        options[:value] || (block.nil? ? name : block.call)
      end

      def inspect
        result = [
          ['name',     name],
          ['parent',   parent && parent.inspect_name],
          ['config',   config.__name],
          ['children', children.map(&:inspect_name)],
          ['options',  options],
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
