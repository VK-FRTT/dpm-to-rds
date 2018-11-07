module WorkbookModel

  class ColumnInfo
    attr_reader :column_name

    def initialize(column_name)
      @column_name = column_name
    end

  end
end
