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
            __node.add_child(node)
            node.config.instance_eval(&blk) if block_given? && (config.__children.size > 0)
          end
        DOC

        self.instance_eval method_defination
      end

      def to_s
        obj_options = {
          'name' => __name,
          'parent' => __parent && __parent.__name,
          'children' => __children.keys,
          'options' => __options,
          'block' => __block
        }
        Qor::Dsl.inspect_object(self, obj_options)
      end
    end
  end
end
