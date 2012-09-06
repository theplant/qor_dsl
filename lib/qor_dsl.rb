require 'qor_dsl/class_method'
require 'qor_dsl/node'

module Qor
  module Dsl
    def self.included(base)
      base.extend ClassMethods
    end
  end
end
