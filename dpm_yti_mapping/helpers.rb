def add_sheet_to_workbook(workbook, sheet_data)
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
