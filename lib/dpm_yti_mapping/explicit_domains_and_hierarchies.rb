require 'securerandom'

module DpmYtiMapping

  class ExplicitDomainsAndHierarchies

    def self.generate_workbooks(owner)
      domain_items = explicit_domain_items_for_owner(owner)

      workbooks = []
      workbooks << log_generated_workbook(DpmYtiMapping::ExplicitDomainsAndHierarchies::DomainsListWorkbook.generate_workbook(domain_items))

      domain_items.each { |domain_item|
        workbooks << log_generated_workbook(DpmYtiMapping::ExplicitDomainsAndHierarchies::MembersWorkbook.generate_workbook(domain_item))
      }

      workbooks
    end

    private

    def self.explicit_domain_items_for_owner(owner)

      DpmDbModel::Domain.explicit.for_owner(owner).all_sorted_naturally_by_domcode.map { |domain|

        members = DpmDbModel::Member.for_domain(domain).all_sorted_naturally_by_memcode

        hierarchy_items = DpmDbModel::Hierarchy.for_domain(domain).all_sorted_naturally_by_hiercode.map { |hierarchy|

          nodes = DpmDbModel::HierarchyNode.for_hierarchy(hierarchy).all_sorted_by_order
          hierarchy_kind = resolve_hierarchy_kind(nodes)

          ExplicitDomainsAndHierarchies::HierarchyItem.new(
            hierarchy,
            hierarchy_kind,
            nodes
          )
        }

        default_code = resolve_default_code(members)

        ExplicitDomainsAndHierarchies::DomainItem.new(
          domain,
          members,
          hierarchy_items,
          SecureRandom.uuid,
          default_code,
          create_members_workbook_for_domain?(domain)
        )
      }
    end


    def self.resolve_default_code(members)
      default_member = members.find { |member| member.IsDefaultMember }

      return nil unless default_member

      default_member.MemberCode
    end


    def self.create_members_workbook_for_domain?(domain)
      return false if domain.DomainCode == 'MET'

      true
    end


    def self.resolve_hierarchy_kind(nodes)
      operator_present = nodes.any? { |node|
        (operator_defined(node.ComparisonOperator) || operator_defined(node.UnaryOperator))
      }

      operator_present ? YtiRds::Constants::ExtensionTypes::CALCULATION_HIERARCHY : YtiRds::Constants::ExtensionTypes::DEFINITION_HIERARCHY
    end


    def self.operator_defined(operator)
      return false if operator.nil?
      return false if operator.empty?
      true
    end
  end
end
