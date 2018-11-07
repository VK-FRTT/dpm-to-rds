# frozen_string_literal: true

module DpmYtiMapping

  class ExplicitDomainsAndHierarchies

    class DomainItem
      attr_reader :domain_model
      attr_reader :member_items
      attr_reader :hierarchy_items
      attr_reader :domain_uuid
      attr_reader :default_code
      attr_reader :create_members_workbook

      def initialize(domain_model, member_items, hierarchy_items, domain_uuid, default_code, create_members_workbook)
        @domain_model = domain_model
        @member_items = member_items
        @hierarchy_items = hierarchy_items
        @domain_uuid = domain_uuid
        @default_code = default_code
        @create_members_workbook = create_members_workbook
      end
    end
  end
end
