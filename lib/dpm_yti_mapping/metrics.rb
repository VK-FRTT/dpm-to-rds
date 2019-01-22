require 'securerandom'

module DpmYtiMapping

  class Metrics

    def self.generate_workbooks(owner)
      workbooks = []

      workbooks << log_generated_workbook(
        DpmYtiMapping::Metrics::MetricsListWorkbook.generate_workbook(
          DpmDbModel::Metric.for_owner(owner).all_sorted_naturally_by_member_code_number,
          metric_hierarchies_for_owner(owner)
        )
      )

      workbooks
    end

    private

    def self.metric_hierarchies_for_owner(owner)

      metric_domain = DpmDbModel::Domain.met_domain().first

      hierarchies = DpmDbModel::Hierarchy.for_domain_and_owner(metric_domain, owner).all_sorted_naturally_by_hiercode

      hierarchy_items = hierarchies.map { |hierarchy|

        nodes = DpmDbModel::HierarchyNode.for_hierarchy(hierarchy).all_sorted_by_order

        Metrics::MetricHierarchyItem.new(
          hierarchy,
          nodes
        )
      }

      hierarchy_items
    end
  end
end
