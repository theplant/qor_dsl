module Qor
  module Dsl
    class Node
      attr_accessor :name, :config, :parent, :children

      def initialize(name=nil, options={})
        self.name   = name
        self.config = options[:config] || Qor::Dsl::Config.new('ROOT', self)
      end

      def node(*arguments)
        config.node(*arguments)
      end

      def children
        @children ||= []
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
        selected_children
      end

      def first(type=nil, name=nil)
        selected_children = find(type, name)
        selected_children.is_a? Array ? selected_children[0] : selected_children
      end
    end
  end
end
