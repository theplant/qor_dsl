require 'qor_dsl/class_method'

module Qor
  module Dsl
    def self.included(base)
      base.extend ClassMethods
    end
  end
end
