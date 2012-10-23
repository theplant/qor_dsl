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
        summary[value[0]] = value[1] if value[1] && value[1].to_s.length > 0
        summary
      end

      "#<#{obj.class}:0x#{obj.object_id.to_s(16)} #{options.inspect}>"
    end
  end
end
