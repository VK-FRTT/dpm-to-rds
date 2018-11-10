# frozen_string_literal: true

module DpmDbModel

  class Owner < Sequel::Model(:mOwner)

    many_to_one :concept, class: 'DpmDbModel::Concept', key: :ConceptID, primary_key: :ConceptID, read_only: true

    dataset_module do
      def by_name(name)
        where(OwnerName: name).first
      end
    end
  end
end
