# frozen_string_literal: true

module DpmDbModel

  class Member < Sequel::Model(:mMember)

    many_to_one :concept, class: 'DpmDbModel::Concept', key: :ConceptID, primary_key: :ConceptID, read_only: true

    dataset_module do
      def for_domain(domain)
        where(DomainID: domain.DomainID)
      end

      def all_sorted_naturally_by_memcode
        Naturally.sort(all(), by: :MemberCode)
      end
    end
  end
end
