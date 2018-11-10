# frozen_string_literal: true

module DpmYtiMapping

  class ExplicitDomainsAndHierarchies

    class DomainsListWorkbook

      def self.write_workbook(domain_items)
        ap = Axlsx::Package.new
        wb = ap.workbook

        add_sheet_to_workbook(wb, codescheme_sheet_data)
        add_sheet_to_workbook(wb, codes_sheet_data(domain_items))

        file_name = "output/#{YtiRds::Constants.versioned_code('explicit-domains-list')}.xlsx"
        ap.serialize(file_name)
        puts "Wrote: #{file_name}"
      end

      private

      def self.codescheme_sheet_data
        row_data = {
          ID: SecureRandom.uuid,
          CODEVALUE: YtiRds::Constants.versioned_code('exp-doms'),
          INFORMATIONDOMAIN: YtiRds::Constants::INFORMATION_DOMAIN,
          LANGUAGECODE: YtiRds::Constants::LANGUAGE_CODE,
          STATUS: YtiRds::Constants::STATUS,
          DEFAULTCODE: nil,
          PREFLABEL_FI: YtiRds::Constants.versioned_label('Explicit Domains'),
          PREFLABEL_EN: YtiRds::Constants.versioned_label('Explicit Domains'),
          DESCRIPTION_FI: 'Lista Explicit Domaineista. Kukin Domain on linkitetty koodistoon, joka määrittää Domainin Meemberit ja Hierarkiat',
          DESCRIPTION_EN: 'List of Explicit Domains. Each Domain is linked to Codelist, listing Domain\'s Members and Hierarchies',
          STARTDATE: nil,
          ENDDATE: nil,
          CODESSHEET: YtiRds::Sheets.codes_name,
          EXTENSIONSSHEET: nil
        }

        WorkbookModel::SheetData.new(
          YtiRds::Sheets.codescheme_name,
          YtiRds::Sheets.codescheme_columns,
          [row_data]
        )
      end

      def self.codes_sheet_data(domain_items)
        rows = domain_items.map do |domain_item|

          d = domain_item.domain_model

          {
            ID: SecureRandom.uuid,
            CODEVALUE: d.DomainCode,
            BROADER: nil,
            STATUS: YtiRds::Constants::STATUS,
            PREFLABEL_FI: d.concept.label_fi,
            PREFLABEL_EN: d.concept.label_en,
            DESCRIPTION_FI: d.concept.description_fi,
            DESCRIPTION_EN: d.concept.description_en,
            STARTDATE: d.concept.start_date_iso8601,
            ENDDATE: d.concept.end_date_iso8601,
            SHORTNAME: "Members in: #{domain_item.domain_members_codescheme_uuid}"
          }
        end

        WorkbookModel::SheetData.new(
          YtiRds::Sheets.codes_name,
          YtiRds::Sheets.codes_with_shortname_columns,
          rows
        )
      end
    end
  end
end
