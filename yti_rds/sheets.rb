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

    def self.extensions_name
      'Extensions'
    end

    private

    def self.columnInfo(column_name)
      WorkbookModel::ColumnInfo.new(column_name)
    end

  end
end
