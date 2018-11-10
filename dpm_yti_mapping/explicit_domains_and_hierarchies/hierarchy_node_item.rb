# frozen_string_literal: true

module DpmYtiMapping

  class ExplicitDomainsAndHierarchies

    class HierarchyNodeItem

      attr_reader :hierarchy_node_model
      attr_reader :hierarchy_node_uuid

      def initialize(hierarchy_node_model, hierarchy_node_uuid)
        @hierarchy_node_model = hierarchy_node_model
        @hierarchy_node_uuid = hierarchy_node_uuid
      end
    end
  end
end

