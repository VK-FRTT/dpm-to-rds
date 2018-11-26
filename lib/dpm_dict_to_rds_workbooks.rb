require 'fileutils'
require 'sequel'
require 'axlsx'

puts "Generating workbooks for YTI Reference Data import from Data Point Model database (SQLite)"

DB = Sequel.connect('sqlite://../dpm-fi-sbr-38.db')

Dir['./dpm_db_model/*.rb'].each { |f| require f }
Dir['./workbook_model/*.rb'].each { |f| require f }
Dir['./yti_rds/**/*.rb'].each { |f| require f }
Dir['./dpm_yti_mapping/**/*.rb'].each { |f| require f }
Dir['./workbook_output/*.rb'].each { |f| require f }

owner = DpmDbModel::Owner.by_name('Suomi SBR')

dir_name = '../output'
unless File.directory?(dir_name)
  FileUtils.mkdir_p(dir_name)
end

WorkbookOutput::Writer.write_workbooks(
  DpmYtiMapping::Metrics.generate_workbooks(owner)
)

WorkbookOutput::Writer.write_workbooks(
  DpmYtiMapping::ExplicitDomainsAndHierarchies.generate_workbooks(owner)
)

WorkbookOutput::Writer.write_workbooks(
  DpmYtiMapping::TypedDomains.generate_workbooks(owner)
)

WorkbookOutput::Writer.write_workbooks(
  DpmYtiMapping::Dimensions.generate_workbooks(owner)
)
