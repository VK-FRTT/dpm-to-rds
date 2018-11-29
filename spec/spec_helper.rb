RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.filter_run :focus
  config.run_all_when_everything_filtered = true
end

require 'sequel'

DB = Sequel.connect('sqlite://spec/fixtures/dm_integration.db')

Dir['./lib/dpm_db_model/*.rb'].each { |f| require f }
Dir['./lib/workbook_model/*.rb'].each { |f| require f }
Dir['./lib/yti_rds/**/*.rb'].each { |f| require f }
Dir['./lib/dpm_yti_mapping/**/*.rb'].each { |f| require f }

def expect_each_sheet(workbooks, workbook_name, expected_sheet_count)
  workbook = workbooks.find { |it| it.workbook_name == workbook_name }
  expect(workbook).to be_an_instance_of(WorkbookModel::WorkbookData)

  expect(workbook.sheets.length).to eq expected_sheet_count

  if block_given?
    workbook.sheets.each_with_index { |row, index| yield row, index }
  end
end

def expect_each_row(workbooks, workbook_name, sheet_name, expected_row_count)
  workbook = workbooks.find { |it| it.workbook_name == workbook_name }
  expect(workbook).to be_an_instance_of(WorkbookModel::WorkbookData)

  sheet = workbook.sheets.find { |it| it.sheet_name == sheet_name }
  expect(sheet).to be_an_instance_of(WorkbookModel::SheetData)

  expect(sheet.rows.length).to eq expected_row_count

  sheet.rows.each_with_index { |row, index| yield row, index }
end

def codescheme_id_from(workbooks, codescheme_codevalue)
  workbooks.each do |workbook|
    workbook.sheets.each do |sheet|
      next unless sheet.sheet_name == 'CodeSchemes'

      row0 = sheet.rows[0]

      if row0[:CODEVALUE] == codescheme_codevalue
        return row0[:ID]
      end

    end
  end

  nil
end
