# frozen_string_literal: true

module DpmDbModel

  class Member < Sequel::Model(:mMember)
    dataset_module do
      def for_domain(domain)
        where(DomainID: domain.DomainID)
      end
    end
  end

end
