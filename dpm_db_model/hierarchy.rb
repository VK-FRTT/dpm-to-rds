# frozen_string_literal: true

module DpmDbModel

  class Hierarchy < Sequel::Model(:mHierarchy)

    dataset_module do
      def for_domain(domain_id)
        where(DomainID: domain_id)
      end
    end
  end

end
