# frozen_string_literal: true

module DpmDbModel

  class Domain < Sequel::Model(:mDomain)
    one_to_one :concept, class: 'DpmDbModel::Concept', key: :ConceptID, read_only: true

    dataset_module do
      def explicit()
        where(IsTypedDomain: false)
      end

      def typed()
        where(IsTypedDomain: true)
      end

      def for_owner(owner)
        association_join(:concept).
          where(OwnerId: owner.OwnerID)
      end
    end
  end

end
