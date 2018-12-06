# frozen_string_literal: true

module DpmYtiMapping

  class TypedDomains

    class TypedDomainsListWorkbook

      def self.generate_workbook(domains)
        WorkbookModel::WorkbookData.new(
          "#{YtiRds::Constants.versioned_code('typed-domains')}",
          [
            codescheme_sd,
            codes_sd(domains),
            typed_domain_extension_sd,
            typed_domain_extension_members_sd(domains)
          ]
        )
      end

      private

      def self.codescheme_sd
        row_data = {
          ID: SecureRandom.uuid,
          CODEVALUE: YtiRds::Constants.versioned_code('typ-doms'),
          INFORMATIONDOMAIN: YtiRds::Constants::INFORMATION_DOMAIN,
          LANGUAGECODE: YtiRds::Constants::LANGUAGE_CODE,
          STATUS: YtiRds::Constants::STATUS,
          DEFAULTCODE: nil,
          PREFLABEL_FI: YtiRds::Constants.versioned_label('Typed Domains'),
          PREFLABEL_EN: nil,
          DESCRIPTION_FI: 'Lista Typed Domaineista.',
          DESCRIPTION_EN: nil,
          STARTDATE: nil,
          ENDDATE: nil,
          CODESSHEET: YtiRds::Sheets.codes_name,
          EXTENSIONSSHEET: YtiRds::Sheets.extensions_name,
        }

        WorkbookModel::SheetData.new(
          YtiRds::Sheets.codescheme_name,
          YtiRds::Sheets.codescheme_columns,
          [row_data]
        )
      end

      def self.codes_sd(domains)
        rows = domains.map do |dom|
          {
            ID: SecureRandom.uuid,
            CODEVALUE: dom.DomainCode,
            BROADER: nil,
            STATUS: YtiRds::Constants::STATUS,
            PREFLABEL_FI: dom.concept.label_fi,
            PREFLABEL_EN: dom.concept.label_en,
            DESCRIPTION_FI: dom.concept.description_fi,
            DESCRIPTION_EN: dom.concept.description_en,
            STARTDATE: dom.concept.start_date_iso8601,
            ENDDATE: dom.concept.end_date_iso8601
          }
        end

        WorkbookModel::SheetData.new(
          YtiRds::Sheets.codes_name,
          YtiRds::Sheets.codes_columns,
          rows
        )
      end

      def self.typed_domain_extension_sd
        row = {
          ID: SecureRandom.uuid,
          CODEVALUE: YtiRds::Constants::ExtensionTypes::DPM_TYPED_DOMAIN,
          STATUS: YtiRds::Constants::STATUS,
          PROPERTYTYPE: YtiRds::Constants::ExtensionTypes::DPM_TYPED_DOMAIN,
          PREFLABEL_FI: nil,
          PREFLABEL_EN: nil,
          STARTDATE: nil,
          ENDDATE: nil,
          MEMBERSSHEET: YtiRds::Sheets.extension_members_name(
            YtiRds::Constants::ExtensionTypes::DPM_TYPED_DOMAIN
          )
        }

        WorkbookModel::SheetData.new(
          YtiRds::Sheets.extensions_name,
          YtiRds::Sheets.extensions_columns,
          [row]
        )
      end

      def self.typed_domain_extension_members_sd(domains)

        rows = domains.map do |dom|
          {
            ID: SecureRandom.uuid,
            CODE: dom.DomainCode,
            DPMDOMAINDATATYPE: dpm_domain_data_type_to_yti(dom.DataType)
          }
        end

        WorkbookModel::SheetData.new(
          YtiRds::Sheets.extension_members_name(YtiRds::Constants::ExtensionTypes::DPM_TYPED_DOMAIN),
          YtiRds::Sheets.extension_members_columns(YtiRds::Constants::ExtensionTypes::DPM_TYPED_DOMAIN),
          rows
        )
      end

      def self.dpm_domain_data_type_to_yti(dpm_data_type)
        mapping = {
          'Boolean' => 'Boolean',
          'Date' => 'Date',
          'Integer' => 'Integer',
          'Monetary' => 'Monetary',
          'Percent' => 'Percentage',
          'String' => 'String',
          'Decimal' => 'Decimal'
        }

        yti_value = mapping[dpm_data_type]

        if !mapping.key?(dpm_data_type) || yti_value.nil?
          raise("Unsupported DPM Domain data type: [#{dpm_data_type}]")
        end

        yti_value
      end
    end
  end
end
