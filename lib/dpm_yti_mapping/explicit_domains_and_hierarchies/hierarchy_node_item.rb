# frozen_string_literal: true

module DpmYtiMapping

  class ExplicitDomainsAndHierarchies

    class HierarchyNodeItem

      attr_reader :hierarchy_node_model

      def initialize(hierarchy_node_model)
        @hierarchy_node_model = hierarchy_node_model
      end
    end
  end
end

