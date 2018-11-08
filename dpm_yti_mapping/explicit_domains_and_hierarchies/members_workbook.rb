# frozen_string_literal: true

module DpmYtiMapping

  class ExplicitDomainsAndHierarchies

    class MembersWorkbook

      def self.write_workbook(domain_item)
        return unless domain_item.create_members_workbook

        p = Axlsx::Package.new
        wb = p.workbook

        add_sheet(wb, codescheme_sheet_data(domain_item))
        add_sheet(wb, codes_sheet_data(domain_item))


        p.serialize("output/domain-members-and-hierarchies-#{domain_item.domain_model.DomainCode}.xlsx")
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


      def self.add_sheet(workbook, sheet_data)
        sheet = workbook.add_worksheet(:name => sheet_data.sheet_name)

        sheet.add_row(sheet_data.columns.map { |column| column.column_name })

        sheet_data.rows.each { |row_data|

          cell_data = sheet_data.columns.map { |column|
            cn = column.column_name

            raise "No row value for column #{cn}" unless row_data.key?(cn)

            row_data[cn]
          }

          sheet.add_row(cell_data)
        }
      end
    end

  end
end
