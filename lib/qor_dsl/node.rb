module Qor
  module Dsl
    class Node
      attr_accessor :config, :parent, :children

      def initialize(options={})
        self.config = options[:config] || Qor::Dsl::Config.new('ROOT', self)
      end

      def node(*arguments)
        config.node(*arguments)
      end

      def add_child(child)
        child.parent = self
        self.children ||= []
        self.children << child
      end
    end
  end
end
