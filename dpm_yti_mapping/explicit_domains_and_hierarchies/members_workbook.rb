# frozen_string_literal: true

module DpmYtiMapping

  class ExplicitDomainsAndHierarchies

    class MembersWorkbook

      def self.write_workbook(domain_item)
        return unless domain_item.create_members_workbook

        ap = Axlsx::Package.new
        wb = ap.workbook

        add_sheet_to_workbook(wb, codescheme_sheet_data(domain_item))
        add_sheet_to_workbook(wb, codes_sheet_data(domain_item))
        add_sheet_to_workbook(wb, extensions_sheet_data(domain_item))

        domain_item.hierarchy_items.map do |hierarchy_item|
          add_sheet_to_workbook(wb, extension_members_sheet_data(hierarchy_item))
        end

        file_name = "output/domain-members-and-hierarchies-#{domain_item.domain_model.DomainCode}.xlsx"
        ap.serialize(file_name)
        puts "Wrote: #{file_name}"
      end

      private

      def self.codescheme_sheet_data(domain_item)
        dm = domain_item.domain_model

        row_data = {
          ID: domain_item.domain_uuid,
          CODEVALUE: dm.DomainCode,
          INFORMATIONDOMAIN: YtiRds::Constants.information_domain,
          LANGUAGECODE: YtiRds::Constants.language_code,
          STATUS: YtiRds::Constants.status,
          DEFAULTCODE: domain_item.default_code,
          PREFLABEL_FI: dm.concept.label_fi,
          PREFLABEL_EN: dm.concept.label_en,
          DESCRIPTION_FI: dm.concept.description_fi,
          DESCRIPTION_EN: dm.concept.description_en,
          STARTDATE: dm.concept.start_date_iso8601,
          ENDDATE: dm.concept.end_date_iso8601,
          CODESSHEET: YtiRds::Sheets.codes_name,
          EXTENSIONSSHEET: YtiRds::Sheets.extensions_name
        }

        WorkbookModel::SheetData.new(YtiRds::Sheets.codescheme_name, YtiRds::Sheets.codescheme_columns, [row_data])
      end

      def self.codes_sheet_data(domain_item)
        rows = domain_item.member_items.map do |member_item|

          m = member_item.member_model

          {
            ID: member_item.member_uuid,
            CODEVALUE: m.MemberCode,
            BROADER: nil,
            STATUS: YtiRds::Constants.status,
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
            ID: hierarchy_item.hierarchy_uuid,
            CODEVALUE: h.HierarchyCode,
            STATUS: YtiRds::Constants.status,
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
            ID: hierarchy_node_item.hierarchy_node_uuid,
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

        if hierarchy_item.hierarchy_kind == YtiRds::Constants.definition_hierarchy
          columns = YtiRds::Sheets.defhier_extension_members_columns
        elsif hierarchy_item.hierarchy_kind == YtiRds::Constants.calculation_hierarchy
          columns = YtiRds::Sheets.calchier_extension_members_columns
        else
          raise "Unsupported extension hierarchy kind: #{hierarchy_item.hierarchy_kind}"
        end

        WorkbookModel::SheetData.new(
          YtiRds::Sheets.extension_members_name(h.HierarchyCode),
          columns,
          rows
        )
      end
    end
  end
end
