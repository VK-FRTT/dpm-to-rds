# frozen_string_literal: true

module DpmYtiMapping

  class Dimensions

    class DimensionsListWorkbook

      def self.generate_workbook_explicit(dimensions)
        WorkbookModel::WorkbookData.new(
          "#{YtiRds::Constants.versioned_code('explicit-dimensions')}",
          [
            explicit_dimension_codescheme_sd,
            codes_sd(dimensions),
            dimension_extension_sd,
            dimension_extension_members_sd(dimensions)
          ]
        )
      end


      def self.generate_workbook_typed(dimensions)
        WorkbookModel::WorkbookData.new(
          "#{YtiRds::Constants.versioned_code('typed-dimensions')}",
          [
            typed_dimension_codescheme_sd,
            codes_sd(dimensions),
            dimension_extension_sd,
            dimension_extension_members_sd(dimensions)
          ]
        )
      end

      private

      def self.explicit_dimension_codescheme_sd
        row_data = {
          ID: SecureRandom.uuid,
          CODEVALUE: YtiRds::Constants.versioned_code('exp-dims'),
          INFORMATIONDOMAIN: YtiRds::Constants::INFORMATION_DOMAIN,
          LANGUAGECODE: YtiRds::Constants::LANGUAGE_CODE,
          STATUS: YtiRds::Constants::STATUS,
          DEFAULTCODE: nil,
          PREFLABEL_FI: YtiRds::Constants.versioned_label('Explicit Dimensions'),
          PREFLABEL_EN: nil,
          DESCRIPTION_FI: 'Lista Explicit Dimensioista.',
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

      def self.typed_dimension_codescheme_sd
        row_data = {
          ID: SecureRandom.uuid,
          CODEVALUE: YtiRds::Constants.versioned_code('typ-dims'),
          INFORMATIONDOMAIN: YtiRds::Constants::INFORMATION_DOMAIN,
          LANGUAGECODE: YtiRds::Constants::LANGUAGE_CODE,
          STATUS: YtiRds::Constants::STATUS,
          DEFAULTCODE: nil,
          PREFLABEL_FI: YtiRds::Constants.versioned_label('Typed Dimensions'),
          PREFLABEL_EN: nil,
          DESCRIPTION_FI: 'Lista Typed Dimensioista.',
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

      def self.codes_sd(dimensions)
        rows = dimensions.map do |dim|
          {
            ID: SecureRandom.uuid,
            CODEVALUE: dim.DimensionCode,
            BROADER: nil,
            STATUS: YtiRds::Constants::STATUS,
            PREFLABEL_FI: dim.concept.label_fi,
            PREFLABEL_EN: dim.concept.label_en,
            DESCRIPTION_FI: dim.concept.description_fi,
            DESCRIPTION_EN: dim.concept.description_en,
            STARTDATE: dim.concept.start_date_iso8601,
            ENDDATE: dim.concept.end_date_iso8601
          }
        end

        WorkbookModel::SheetData.new(
          YtiRds::Sheets.codes_name,
          YtiRds::Sheets.codes_columns,
          rows
        )
      end

      def self.dimension_extension_sd
        row = {
          ID: SecureRandom.uuid,
          CODEVALUE: YtiRds::Constants::ExtensionTypes::DPM_DIMENSION,
          STATUS: YtiRds::Constants::STATUS,
          PROPERTYTYPE: YtiRds::Constants::ExtensionTypes::DPM_DIMENSION,
          PREFLABEL_FI: nil,
          PREFLABEL_EN: nil,
          STARTDATE: nil,
          ENDDATE: nil,
          MEMBERSSHEET: YtiRds::Sheets.extension_members_name(
            YtiRds::Constants::ExtensionTypes::DPM_DIMENSION
          )
        }

        WorkbookModel::SheetData.new(
          YtiRds::Sheets.extensions_name,
          YtiRds::Sheets.extensions_columns,
          [row]
        )
      end

      def self.dimension_extension_members_sd(dimensions)

        rows = dimensions.map do |dim|
          {
            ID: SecureRandom.uuid,
            CODE: dim.DimensionCode,
            DPMDOMAINREFERENCE: dim.domain.DomainCode
          }
        end

        WorkbookModel::SheetData.new(
          YtiRds::Sheets.extension_members_name(YtiRds::Constants::ExtensionTypes::DPM_DIMENSION),
          YtiRds::Sheets.extension_members_columns(YtiRds::Constants::ExtensionTypes::DPM_DIMENSION),
          rows
        )
      end
    end
  end
end
