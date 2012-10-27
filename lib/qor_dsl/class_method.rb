module Qor
  module Dsl
    module ClassMethods
      @@lock = Mutex.new
      def node_root
        @node_root ||= Qor::Dsl::Node.new
      end

      def reset!
        node_config = node_root.config
        @node_root = Qor::Dsl::Node.new
        @node_root.add_config(node_config)
        @root = nil
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
          @default_configs.select {|x| File.exist?(x.to_s) }[0]
        else
          @default_configs
        end
      end

      def load(path=nil, opts={}, &block)
        @@lock.synchronize do
          reset! if opts[:force] || block_given?

          @root ||= if block_given? # Load from block
                      node_root.config.instance_eval(&block)
                      node_root
                    else # Load from file
                      @load_path = path || @load_path || default_config
                      load_file(@load_path)
                    end
        end
      end

      def load_file(file)
        raise Qor::Dsl::ConfigurationNotFound unless File.exist?(file.to_s)
        node_root.config.instance_eval(File.read(file))
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
