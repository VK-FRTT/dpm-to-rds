module WorkbookModel
  class SheetData
    attr_reader :sheet_name
    attr_reader :columns
    attr_reader :rows

    def initialize(sheet_name, columns, rows)
      @sheet_name = sheet_name
      @columns = columns
      @rows = rows
    end

  end
end