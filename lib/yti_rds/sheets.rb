# frozen_string_literal: true

module YtiRds
  class Sheets

    def self.codescheme_name
      'CodeSchemes'
    end

    def self.codescheme_columns
      [
        columnInfo(:ID),
        columnInfo(:CODEVALUE),
        columnInfo(:INFORMATIONDOMAIN),
        columnInfo(:LANGUAGECODE),
        columnInfo(:STATUS),
        columnInfo(:DEFAULTCODE),
        columnInfo(:PREFLABEL_FI),
        columnInfo(:PREFLABEL_EN),
        columnInfo(:DESCRIPTION_FI),
        columnInfo(:DESCRIPTION_EN),
        columnInfo(:STARTDATE),
        columnInfo(:ENDDATE),
        columnInfo(:CODESSHEET),
        columnInfo(:EXTENSIONSSHEET)
      ]
    end

    def self.codes_name
      'Codes'
    end

    def self.codes_columns
      [
        columnInfo(:ID),
        columnInfo(:CODEVALUE),
        columnInfo(:BROADER),
        columnInfo(:STATUS),
        columnInfo(:PREFLABEL_FI),
        columnInfo(:PREFLABEL_EN),
        columnInfo(:DESCRIPTION_FI),
        columnInfo(:DESCRIPTION_EN),
        columnInfo(:STARTDATE),
        columnInfo(:ENDDATE)
      ]
    end

    def self.codes_with_shortname_columns
      [
        columnInfo(:ID),
        columnInfo(:CODEVALUE),
        columnInfo(:BROADER),
        columnInfo(:STATUS),
        columnInfo(:PREFLABEL_FI),
        columnInfo(:PREFLABEL_EN),
        columnInfo(:DESCRIPTION_FI),
        columnInfo(:DESCRIPTION_EN),
        columnInfo(:STARTDATE),
        columnInfo(:ENDDATE),
        columnInfo(:SHORTNAME)
      ]
    end

    def self.extensions_name
      'Extensions'
    end

    def self.extensions_columns
      [
        columnInfo(:ID),
        columnInfo(:CODEVALUE),
        columnInfo(:STATUS),
        columnInfo(:PROPERTYTYPE),
        columnInfo(:PREFLABEL_FI),
        columnInfo(:PREFLABEL_EN),
        columnInfo(:STARTDATE),
        columnInfo(:ENDDATE),
        columnInfo(:MEMBERSSHEET)
      ]
    end

    def self.extension_members_name(extension_code)
      "Members_#{extension_code}"
    end

    def self.extension_members_columns(extension_type)

      if extension_type == YtiRds::Constants::ExtensionTypes::DEFINITION_HIERARCHY
        return [
          columnInfo(:ID),
          columnInfo(:CODE),
          columnInfo(:RELATION),
          columnInfo(:PREFLABEL_FI),
          columnInfo(:PREFLABEL_EN),
          columnInfo(:STARTDATE),
          columnInfo(:ENDDATE)
        ]
      end

      if extension_type == YtiRds::Constants::ExtensionTypes::CALCULATION_HIERARCHY
        return [
          columnInfo(:ID),
          columnInfo(:CODE),
          columnInfo(:RELATION),
          columnInfo(:UNARYOPERATOR),
          columnInfo(:COMPARISONOPERATOR),
          columnInfo(:PREFLABEL_FI),
          columnInfo(:PREFLABEL_EN),
          columnInfo(:STARTDATE),
          columnInfo(:ENDDATE)
        ]
      end

      if extension_type == YtiRds::Constants::ExtensionTypes::DPM_DIMENSION
        return [
          columnInfo(:ID),
          columnInfo(:CODE),
          columnInfo(:DPMDOMAINREFERENCE)
        ]
      end

      if extension_type == YtiRds::Constants::ExtensionTypes::DPM_TYPED_DOMAIN
        return [
          columnInfo(:ID),
          columnInfo(:CODE),
          columnInfo(:DPMDATATYPE)
        ]
      end

      if extension_type == YtiRds::Constants::ExtensionTypes::DPM_METRIC
        return [
          columnInfo(:ID),
          columnInfo(:CODE),
          columnInfo(:DPMDATATYPE),
          columnInfo(:DPMFLOWTYPE),
          columnInfo(:DPMBALANCETYPE),
          columnInfo(:DPMDOMAINREFERENCE),
          columnInfo(:DPMHIERARCHYREFERENCE),
        ]
      end

      raise "Unsupported extension type: #{extension_type}"
    end

    private

    def self.columnInfo(column_name)
      WorkbookModel::ColumnInfo.new(column_name)
    end

  end
end
