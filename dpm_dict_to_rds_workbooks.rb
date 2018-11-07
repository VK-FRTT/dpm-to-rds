require 'fileutils'
require 'sequel'
require 'axlsx'

puts "Generating workbooks for YTI Reference Data import from Data Point Model database (SQLite)"

DB = Sequel.connect('sqlite://dpm-fi-sbr-35.db')

Dir['./dpm_db_model/*.rb'].each {|f| require f}
Dir['./workbook_model/*.rb'].each {|f| require f}
Dir['./yti_rds/**/*.rb'].each {|f| require f}
Dir['./dpm_yti_mapping/**/*.rb'].each {|f| require f}

owner = DpmDbModel::Owner.by_name('Suomi SBR')

dname = 'output'
unless File.directory?(dname)
  FileUtils.mkdir_p(dname)
end

DpmYtiMapping::ExplicitDomainsAndHierarchies.write_workbooks(owner)
