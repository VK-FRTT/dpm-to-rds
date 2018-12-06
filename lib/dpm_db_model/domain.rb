# frozen_string_literal: true

module DpmDbModel

  class Domain < Sequel::Model(:mDomain)

    many_to_one :concept, class: 'DpmDbModel::Concept', key: :ConceptID, primary_key: :ConceptID, read_only: true

    dataset_module do
      def explicit()
        where(IsTypedDomain: false)
      end

      def typed()
        where(IsTypedDomain: true)
      end

      def for_owner(owner)
        association_join(:concept).where(OwnerId: owner.OwnerID)
      end

      def all_sorted_naturally_by_domcode
        Naturally.sort(all(), by: :DomainCode)
      end

    end
  end
end
