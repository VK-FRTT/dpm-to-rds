# frozen_string_literal: true

module DpmYtiMapping

  class ExplicitDomainsAndHierarchies

    class HierarchyItem

      attr_reader :hierarchy
      attr_reader :hierarchy_kind
      attr_reader :nodes

      def initialize(hierarchy, hierarchy_kind, nodes)
        @hierarchy = hierarchy
        @hierarchy_kind = hierarchy_kind
        @nodes = nodes
      end
    end
  end
end

