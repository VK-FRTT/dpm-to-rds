module WorkbookOutput
  class Writer

    def self.write_workbooks(workbook_models)
      workbook_models.each { |workbook_model| write_workbook(workbook_model) }
    end

    private

    def self.write_workbook(workbook_model)
      ap = Axlsx::Package.new
      wb = ap.workbook

      workbook_model.sheets.each { |sheet| add_sheet_to_workbook(sheet, wb) }

      ap.serialize(workbook_model.workbook_file_name)
      puts "Wrote: #{workbook_model.workbook_file_name}"
    end

    def self.add_sheet_to_workbook(sheet_data, workbook)
      sheet = workbook.add_worksheet(:name => sheet_data.sheet_name)

      sheet.add_row(sheet_data.columns.map { |column| column.column_name })

      sheet_data.rows.each { |row_data|

        cell_data = sheet_data.columns.map { |column|
          cn = column.column_name

          raise "No row value for column #{cn}" unless row_data.key?(cn)

          row_data[cn]
        }

        sheet.add_row(cell_data)
      }
    end
  end
end