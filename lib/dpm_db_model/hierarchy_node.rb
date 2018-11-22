# frozen_string_literal: true

module DpmDbModel

  class HierarchyNode < Sequel::Model(:mHierarchyNode)

    many_to_one :concept, class: 'DpmDbModel::Concept', key: :ConceptID, primary_key: :ConceptID, read_only: true
    many_to_one :member, class: 'DpmDbModel::Member', key: :MemberID, primary_key: :MemberID, read_only: true
    many_to_one :parent_member, class: 'DpmDbModel::Member', key: :ParentMemberID, primary_key: :MemberID, read_only: true

    dataset_module do
      def for_hierarchy(hierarchy)
        where(HierarchyID: hierarchy.HierarchyID)
      end
    end
  end
end
