module Qor
  module Dsl
    class Config
      attr_accessor :__node, :__name, :__parent, :__children, :__options, :__block

      def initialize type, node=nil
        self.__name = type
        self.__node = node
      end

      def node(type, options={}, &blk)
        child = Qor::Dsl::Config.new(type)
        child.instance_eval(&blk) if block_given?
        __add_child(type, options, child)

        self
      end

      def __children
        @__children ||= {}
      end

      def __add_child(type, options, child)
        child.__parent  = self
        child.__options = options
        self.__children[type.to_sym] = child

        method_defination = <<-DOC
          def #{type}(name=nil, *data, &blk)
            config = __children['#{type}'.to_sym]
            node = Qor::Dsl::Node.new(name)
            node.add_config(config)
            node.data = *data
            node.block = blk
            node.config.instance_eval(&blk) if block_given? && (config.__children.size > 0)
            __node.add_child(node)
          end
        DOC

        self.instance_eval method_defination
      end
    end
  end
end
