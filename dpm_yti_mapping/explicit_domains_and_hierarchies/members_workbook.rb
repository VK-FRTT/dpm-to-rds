# frozen_string_literal: true

module DpmYtiMapping

  class ExplicitDomainsAndHierarchies

    class MembersWorkbook

      def self.write_workbook(domain_item)
        return unless domain_item.create_members_workbook

        p = Axlsx::Package.new
        wb = p.workbook

        add_sheet(wb, codescheme_sheet_data(domain_item))

        p.serialize("output/members-and-hierarchies-#{domain_item.domain_model.DomainCode}.xlsx")
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
          STARTDATE: '',
          ENDDATE: '',
          CODESSHEET: '',
          EXTENSIONSSHEET: ''
        }

        WorkbookModel::SheetData.new(YtiRds::Sheets.codescheme_name, YtiRds::Sheets.codescheme_columns, [row_data])
      end

      def self.add_sheet(workbook, sheet_data)
        sheet = workbook.add_worksheet(:name => sheet_data.sheet_name)

        sheet.add_row(sheet_data.columns.map{ |column| column.column_name } )

        sheet_data.rows.each{ |row_data|

          cell_data = sheet_data.columns.map{ |column|
            row_data[column.column_name]
          }

          sheet.add_row(cell_data)
        }
      end
    end

  end
end
