# frozen_string_literal: true

module DpmDbModel

  class Member < Sequel::Model(:mMember)

    one_to_one :concept, class: 'DpmDbModel::Concept', key: :ConceptID, read_only: true

    dataset_module do
      def for_domain(domain)
        where(DomainID: domain.DomainID)
      end
    end
  end

end
