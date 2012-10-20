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
        result = [
          ['name',    __name],
          ['parent',  __parent && __parent.__name],
          ['__children', __children.keys],
          ['options', __options],
          ['block',   __block]
        ].inject({}) do |s, value|
          s[value[0]] = value[1] if value[1] && value[1].to_s.length > 0
          s
        end.inspect

        "#<Qor::Dsl::Config::0x#{object_id.to_s(16)} #{result}>"
      end
    end
  end
end
