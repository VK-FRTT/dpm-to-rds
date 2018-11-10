# frozen_string_literal: true

module DpmYtiMapping

  class ExplicitDomainsAndHierarchies

    class HierarchyItem

      attr_reader :hierarchy_model
      attr_reader :hierarchy_kind
      attr_reader :hierarchy_node_items
      attr_reader :hierarchy_uuid

      def initialize(hierarchy_model, hierarchy_kind, hierarchy_node_items, hierarchy_uuid)
        @hierarchy_model = hierarchy_model
        @hierarchy_kind = hierarchy_kind
        @hierarchy_node_items = hierarchy_node_items
        @hierarchy_uuid = hierarchy_uuid
      end
    end
  end
end

