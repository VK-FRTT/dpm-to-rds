# frozen_string_literal: true

module DpmYtiMapping

  class ExplicitDomainsAndHierarchies

    class MembersWorkbook

      def self.generate_workbook(domain_item)
        sheets = [codescheme_sheet_data(domain_item), codes_sheet_data(domain_item), extensions_sheet_data(domain_item)]

        domain_item.hierarchy_items.map do |hierarchy_item|
          sheets << extension_members_sheet_data(hierarchy_item)
        end

        WorkbookModel::WorkbookData.new(
          "../output/domain-members-and-hierarchies-#{YtiRds::Constants.versioned_code(domain_item.domain_model.DomainCode)}.xlsx",
          sheets
        )
      end

      private

      def self.codescheme_sheet_data(domain_item)
        dm = domain_item.domain_model

        row_data = {
          ID: domain_item.domain_members_codescheme_uuid,
          CODEVALUE: YtiRds::Constants.versioned_code(dm.DomainCode),
          INFORMATIONDOMAIN: YtiRds::Constants::INFORMATION_DOMAIN,
          LANGUAGECODE: YtiRds::Constants::LANGUAGE_CODE,
          STATUS: YtiRds::Constants::STATUS,
          DEFAULTCODE: domain_item.default_code,
          PREFLABEL_FI: YtiRds::Constants.versioned_label(dm.concept.label_fi),
          PREFLABEL_EN: YtiRds::Constants.versioned_label(dm.concept.label_en),
          DESCRIPTION_FI: nil,
          DESCRIPTION_EN: nil,
          STARTDATE: nil,
          ENDDATE: nil,
          CODESSHEET: YtiRds::Sheets.codes_name,
          EXTENSIONSSHEET: YtiRds::Sheets.extensions_name
        }

        WorkbookModel::SheetData.new(
          YtiRds::Sheets.codescheme_name,
          YtiRds::Sheets.codescheme_columns,
          [row_data]
        )
      end

      def self.codes_sheet_data(domain_item)
        rows = domain_item.member_items.map do |member_item|

          m = member_item.member_model

          {
            ID: SecureRandom.uuid,
            CODEVALUE: m.MemberCode,
            BROADER: nil,
            STATUS: YtiRds::Constants::STATUS,
            PREFLABEL_FI: m.concept.label_fi,
            PREFLABEL_EN: m.concept.label_en,
            DESCRIPTION_FI: m.concept.description_fi,
            DESCRIPTION_EN: m.concept.description_en,
            STARTDATE: m.concept.start_date_iso8601,
            ENDDATE: m.concept.end_date_iso8601
          }
        end

        WorkbookModel::SheetData.new(YtiRds::Sheets.codes_name, YtiRds::Sheets.codes_columns, rows)
      end

      def self.extensions_sheet_data(domain_item)
        rows = domain_item.hierarchy_items.map do |hierarchy_item|

          h = hierarchy_item.hierarchy_model

          {
            ID: SecureRandom.uuid,
            CODEVALUE: h.HierarchyCode,
            STATUS: YtiRds::Constants::STATUS,
            PROPERTYTYPE: hierarchy_item.hierarchy_kind,
            PREFLABEL_FI: h.concept.label_fi,
            PREFLABEL_EN: h.concept.label_en,
            STARTDATE: h.concept.start_date_iso8601,
            ENDDATE: h.concept.end_date_iso8601,
            MEMBERSSHEET: YtiRds::Sheets.extension_members_name(h.HierarchyCode)
          }
        end

        WorkbookModel::SheetData.new(YtiRds::Sheets.extensions_name, YtiRds::Sheets.extensions_columns, rows)
      end

      def self.extension_members_sheet_data(hierarchy_item)
        h = hierarchy_item.hierarchy_model

        rows = hierarchy_item
                 .hierarchy_node_items
                 .sort { |a, b| a.hierarchy_node_model.Order <=> b.hierarchy_node_model.Order }
                 .map do |hierarchy_node_item|

          hn = hierarchy_node_item.hierarchy_node_model

          {
            ID: SecureRandom.uuid,
            UNARYOPERATOR: hn.UnaryOperator,
            COMPARISONOPERATOR: hn.ComparisonOperator,
            CODE: hn.member.MemberCode,
            RELATION: hn.parent_member.nil? ? nil : hn.parent_member.MemberCode,
            PREFLABEL_FI: hn.concept.label_fi,
            PREFLABEL_EN: hn.concept.label_en,
            STARTDATE: hn.concept.start_date_iso8601,
            ENDDATE: hn.concept.end_date_iso8601
          }
        end

        WorkbookModel::SheetData.new(
          YtiRds::Sheets.extension_members_name(h.HierarchyCode),
          YtiRds::Sheets.extension_members_columns(hierarchy_item.hierarchy_kind),
          rows
        )
      end
    end
  end
end
