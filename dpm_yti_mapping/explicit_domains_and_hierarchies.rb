require 'securerandom'

module DpmYtiMapping

  class ExplicitDomainsAndHierarchies

    def self.write_workbooks(owner)
      domain_items = domain_items_for_owner(owner)

      domain_items.each { |domain_item|
        DpmYtiMapping::ExplicitDomainsAndHierarchies::MembersWorkbook.write_workbook(domain_item)
      }

      DpmYtiMapping::ExplicitDomainsAndHierarchies::DomainsWorkbook.write_workbook(domain_items)
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
          member,
          SecureRandom.uuid
        )
      }
    end

    def self.hierarchy_items(domain)
      hierarchy_items = [] #TODO
    end

    def self.default_code(member_items)
      default_member_item = member_items.find { |item| item.member_model.IsDefaultMember }

      return '' unless default_member_item

      default_member_item.member_model.MemberCode
    end

    def self.create_members_workbook_for_domain?(domain)
      return false if domain.DomainCode == 'MET'

      true
    end
  end
end
