module WorkbookModel
  class WorkbookData
    attr_reader :workbook_name
    attr_reader :sheets

    def initialize(workbook_name, sheets)
      @workbook_name = workbook_name
      @sheets = sheets
    end

  end
end