module WorkbookOutput
  class Writer

    SUPPRESS_IDS = false

    def self.write_workbooks(workbook_models)
      workbook_models.each { |workbook_model| write_workbook(workbook_model) }
    end

    private

    def self.write_workbook(workbook_model)
      ap = Axlsx::Package.new
      wb = ap.workbook

      workbook_model.sheets.each { |sheet| add_sheet_to_workbook(sheet, wb) }

      if SUPPRESS_IDS
        target_file_name = "../output/#{workbook_model.workbook_name}-no-ids.xlsx"
      else
        target_file_name = "../output/#{workbook_model.workbook_name}.xlsx"
      end

      ap.serialize(target_file_name)
      puts "Wrote: #{target_file_name}"
    end

    def self.add_sheet_to_workbook(sheet_data, workbook)
      sheet = workbook.add_worksheet(:name => sheet_data.sheet_name)

      bold_style = sheet.styles.add_style(:b => true)

      row_types = sheet_data.columns.map { |column| :text }

      header_values = sheet_data.columns.map { |column| column.column_name }

      sheet.add_row(header_values, types: row_types, style: bold_style)

      sheet_data.rows.each { |row_data|

        row_values = sheet_data.columns.map { |column|
          column_name = column.column_name

          raise "No row value for column #{column_name}" unless row_data.key?(column_name)

          cell_value = row_data[column_name]

          if SUPPRESS_IDS && column_name == :ID
            cell_value = nil
          end

          cell_value
        }

        sheet.add_row(row_values, types: row_types)
      }
    end
  end
end