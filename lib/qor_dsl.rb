require 'qor_dsl/exception'
require 'qor_dsl/class_method'
require 'qor_dsl/config'
require 'qor_dsl/node'

module Qor
  module Dsl
    def self.included(base)
      base.extend ClassMethods
    end

    def self.inspect_object(obj, options)
      options = options.inject({}) do |summary, value|
        unless [:nil?, :empty?, :blank?].any? { |method|
          value[1].respond_to?(method) && value[1].send(method)
        }
          summary[value[0]] = value[1]
        end
        summary
      end

      "#<#{obj.class}:0x#{obj.object_id.to_s(16)} #{options.inspect}>"
    end
  end
end

module Qor
  module DSL
    def self.included(base)
      base.send :include, Qor::Dsl
    end
  end
end
