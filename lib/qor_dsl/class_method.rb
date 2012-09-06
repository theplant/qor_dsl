module Qor
  module Dsl
    module ClassMethods
      def node_root
        @node_root ||= Qor::Dsl::Node.new
      end

      def node(*arguments)
        node_root.node(*arguments)
      end

      def root
        @root || load
      end

      def load(path=nil, opts={})
        @load_path = path || @load_path
        @root = (opts[:force] ? nil : @root) || load_file(@load_path)
        @root
      end

      def load_file(file)
        return unless File.exist?(file.to_s)
        content = File.read(file)
        node_root.instance_eval(content)
        node_root
      end

      def find(*arguments)
        root.find(*arguments)
      end

      def first(*arguments)
        root.first(*arguments)
      end
    end
  end
end
