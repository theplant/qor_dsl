module Qor
  module Dsl
    module ClassMethods
      def node_root
        @node_root ||= Qor::Dsl::Node.new
      end

      def node(type, options={}, &blk)
        node_root.node(type, options, &blk)
      end

      def root
        @root || load
      end

      def default_configs(files)
        @default_configs = files
      end

      def default_config
        if @default_configs.is_a?(Array)
          @default_configs.select {|x| File.exist?(x) }[0]
        else
          @default_configs
        end
      end

      def load(path=nil, opts={})
        @load_path, @root = nil, nil if opts[:force]

        @load_path = path || @load_path || default_config
        @root ||= load_file(@load_path)
        @root
      end

      def load_file(file)
        return unless File.exist?(file.to_s)
        content = File.read(file)
        node_root.config.instance_eval(content)
        node_root
      end

      def find(*arguments, &block)
        root.find(*arguments, &block)
      end

      def deep_find(*arguments, &block)
        root.deep_find(*arguments, &block)
      end

      def first(*arguments, &block)
        root.first(*arguments, &block)
      end
    end
  end
end
