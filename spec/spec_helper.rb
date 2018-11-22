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

def expect_each_row(workbooks, workbook_name, sheet_name, expected_row_count)
  workbook = workbooks.find { |it| it.workbook_name == workbook_name }
  expect(workbook).to be_an_instance_of(WorkbookModel::WorkbookData)

  sheet = workbook.sheets.find { |it| it.sheet_name == sheet_name }
  expect(sheet).to be_an_instance_of(WorkbookModel::SheetData)

  expect(sheet.rows.length).to eq expected_row_count

  sheet.rows.each_with_index { |row, index| yield row, index }
end

def verify_code_scheme_row(row)
  expect(row[:ID].length).to be(36)
  expect(row[:INFORMATIONDOMAIN]).to eq('P14')
  expect(row[:LANGUAGECODE]).to eq('fi;sv;en')
  expect(row[:STATUS]).to eq('DRAFT')
  expect(row[:CODESSHEET]).to eq('Codes')
end

def verify_code_row(row)
  expect(row[:ID].length).to be(36)
  expect(row[:STATUS]).to eq('DRAFT')
end
