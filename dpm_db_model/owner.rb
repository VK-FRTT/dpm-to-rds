# frozen_string_literal: true

module DpmDbModel

  class Owner < Sequel::Model(:mOwner)

    dataset_module do
      def by_name(name)
        where(OwnerName: name).first
      end

    end
  end
end
