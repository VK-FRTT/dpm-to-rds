# frozen_string_literal: true

module DpmDbModel

  class HierarchyNode < Sequel::Model(:mHierarchyNode)

    dataset_module do
      def for_hierarchy(hierarchy_id)
        where(HierarchyID: hierarchy_id)
      end
    end

  end

end
