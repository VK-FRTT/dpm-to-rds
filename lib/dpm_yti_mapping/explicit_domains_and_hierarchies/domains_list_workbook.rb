# frozen_string_literal: true

module DpmYtiMapping

  class ExplicitDomainsAndHierarchies

    class DomainsListWorkbook

      def self.generate_workbook(domain_items)
        WorkbookModel::WorkbookData.new(
          "#{YtiRds::Constants.versioned_code('explicit-domains')}",
          [
            codescheme_sd,
            codes_sd(domain_items),
            explicit_domain_extension_sd
          ]
        )
      end

      private

      def self.codescheme_sd
        row_data = {
          ID: SecureRandom.uuid,
          CODEVALUE: YtiRds::Constants.versioned_code('exp-doms'),
          INFORMATIONDOMAIN: YtiRds::Constants::INFORMATION_DOMAIN,
          LANGUAGECODE: YtiRds::Constants::LANGUAGE_CODE,
          STATUS: YtiRds::Constants::STATUS,
          DEFAULTCODE: nil,
          PREFLABEL_FI: YtiRds::Constants.versioned_label('Explicit Domains'),
          PREFLABEL_EN: nil,
          DESCRIPTION_FI: 'Lista Explicit Domaineista. Kukin Domain on linkitetty koodistoon, joka määrittää Domainin Memberit ja Hierarkiat',
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

      def self.codes_sd(domain_items)
        rows = domain_items.map do |domain_item|
          d = domain_item.domain

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
            SUBCODESCHEME: domain_item.domain_members_codescheme_uuid
          }
        end

        WorkbookModel::SheetData.new(
          YtiRds::Sheets.codes_name,
          YtiRds::Sheets.codes_with_subcodescheme,
          rows
        )
      end

      def self.explicit_domain_extension_sd
        row = {
          ID: SecureRandom.uuid,
          CODEVALUE: YtiRds::Constants::ExtensionTypes::DPM_EXPLICIT_DOMAIN,
          STATUS: YtiRds::Constants::STATUS,
          PROPERTYTYPE: YtiRds::Constants::ExtensionTypes::DPM_EXPLICIT_DOMAIN,
          PREFLABEL_FI: nil,
          PREFLABEL_EN: nil,
          STARTDATE: nil,
          ENDDATE: nil,
          MEMBERSSHEET: nil
        }

        WorkbookModel::SheetData.new(
          YtiRds::Sheets.extensions_name,
          YtiRds::Sheets.extensions_columns,
          [row]
        )
      end

    end
  end
end
