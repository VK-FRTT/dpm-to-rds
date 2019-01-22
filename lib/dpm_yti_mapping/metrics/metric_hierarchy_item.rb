# frozen_string_literal: true

module DpmYtiMapping

  class Metrics

    class MetricHierarchyItem

      attr_reader :hierarchy
      attr_reader :nodes

      def initialize(hierarchy, nodes)
        @hierarchy = hierarchy
        @nodes = nodes
      end
    end
  end
end

