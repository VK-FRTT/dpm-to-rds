# frozen_string_literal: true

module DpmYtiMapping

  class ExplicitDomainsAndHierarchies

    class DomainItem
      attr_reader :domain
      attr_reader :members
      attr_reader :hierarchies
      attr_reader :domain_members_codescheme_uuid
      attr_reader :default_code
      attr_reader :create_members_workbook

      def initialize(domain_model, members, hierarchy_items, domain_members_codescheme_uuid, default_code, create_members_workbook)
        @domain = domain_model
        @members = members
        @hierarchies = hierarchy_items
        @domain_members_codescheme_uuid = domain_members_codescheme_uuid
        @default_code = default_code
        @create_members_workbook = create_members_workbook
      end
    end
  end
end
