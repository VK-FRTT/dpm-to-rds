require 'securerandom'

module DpmYtiMapping

  class ExplicitDomainsAndHierarchies

    def self.generate_workbooks(owner)
      domain_items = domain_items_for_owner(owner)

      workbooks = [DpmYtiMapping::ExplicitDomainsAndHierarchies::DomainsListWorkbook.generate_workbook(domain_items)]

      domain_items.each { |domain_item|
        workbooks << DpmYtiMapping::ExplicitDomainsAndHierarchies::MembersWorkbook.generate_workbook(domain_item)
      }

      workbooks
    end

    private

    def self.domain_items_for_owner(owner)

      DpmDbModel::Domain.explicit.for_owner(owner).all.map { |domain|

        member_items = member_items(domain)

        hierarchy_items = hierarchy_items(domain)

        default_code = default_code(member_items)

        ExplicitDomainsAndHierarchies::DomainItem.new(
          domain,
          member_items,
          hierarchy_items,
          SecureRandom.uuid,
          default_code,
          create_members_workbook_for_domain?(domain)
        )
      }
    end

    def self.member_items(domain)
      DpmDbModel::Member.for_domain(domain).all.map { |member|
        ExplicitDomainsAndHierarchies::MemberItem.new(
          member
        )
      }
    end

    def self.hierarchy_items(domain)
      DpmDbModel::Hierarchy.for_domain(domain).all.map { |hierarchy|
        hierarchy_node_items = hierarchy_node_items(hierarchy)
        hierarchy_kind = analyze_hierarchy_kind(hierarchy_node_items)

        ExplicitDomainsAndHierarchies::HierarchyItem.new(
          hierarchy,
          hierarchy_kind,
          hierarchy_node_items
        )
      }
    end

    def self.hierarchy_node_items(hierarchy)
      DpmDbModel::HierarchyNode.for_hierarchy(hierarchy).all.map { |hierarchy_node|
        ExplicitDomainsAndHierarchies::HierarchyNodeItem.new(
          hierarchy_node
        )
      }
    end

    def self.default_code(member_items)
      default_member_item = member_items.find { |item| item.member_model.IsDefaultMember }

      return nil unless default_member_item

      default_member_item.member_model.MemberCode
    end

    def self.create_members_workbook_for_domain?(domain)
      return false if domain.DomainCode == 'MET'

      true
    end

    def self.analyze_hierarchy_kind(hierarchy_node_items)

      ops_present = hierarchy_node_items.any? do |item|
        m = item.hierarchy_node_model
        (op_defined(m.ComparisonOperator) || op_defined(m.UnaryOperator))
      end

      return YtiRds::Constants::ExtensionTypes::CALCULATION_HIERARCHY if ops_present

      YtiRds::Constants::ExtensionTypes::DEFINITION_HIERARCHY
    end

    def self.op_defined(operator)
      return false if operator.nil?
      return false if operator.empty?

      true
    end
  end
end
