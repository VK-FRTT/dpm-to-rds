# frozen_string_literal: true

module DpmYtiMapping

  class ExplicitDomainsAndHierarchies

    class MemberItem

      attr_reader :member_model
      attr_reader :member_uuid

      def initialize(member_model, member_uuid)
        @member_model = member_model
        @member_uuid = member_uuid
      end
    end
  end
end
