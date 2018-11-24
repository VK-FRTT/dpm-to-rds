# frozen_string_literal: true

module DpmYtiMapping

  class ExplicitDomainsAndHierarchies

    class DomainsListWorkbook

      def self.generate_workbook(domain_items)
        WorkbookModel::WorkbookData.new(
          "#{YtiRds::Constants.versioned_code('explicit-domains-list')}",
          [codescheme_sd, codes_sd(domain_items)]
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
          EXTENSIONSSHEET: nil
        }

        WorkbookModel::SheetData.new(
          YtiRds::Sheets.codescheme_name,
          YtiRds::Sheets.codescheme_columns,
          [row_data]
        )
      end

      def self.codes_sd(domain_items)
        # NOTE: Plain lexicographic sort is used for now
        # Probably natural sort (for handling inline numbers) should be taken into use..
        rows = domain_items
                 .sort { |a, b| a.domain_model.DomainCode <=> b.domain_model.DomainCode }
                 .map do |domain_item|
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
            SHORTNAME: "Members in: #{domain_item.domain_members_codescheme_uuid}" #Temporary hack until proper linking gets in place
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
