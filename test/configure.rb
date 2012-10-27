require 'qor_dsl'

module Layout
  module Configuration
    include Qor::DSL

    node :template

    node :gadget do
      node :desc

      node :settings do
        node :meta
      end

      node :context
      node :template, :inherit => true
    end

    node :layout do
      node :description, :default_value => "TODO"
      node :description_block, :default_block => proc {|x| 'FIXME' }
      node :gadgets
    end

    node :action do
      node :desc
      node :detect
      node :add_permission, {:allow_multi => true}

      # alias_node :grand, :add_permission, {:name => "grand", :options => {}}, {:allow_multi => false}
    end
  end
end
