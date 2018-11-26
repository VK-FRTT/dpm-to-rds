require 'rspec'

RSpec.describe DpmYtiMapping::TypedDomains do

  let(:owner) { DpmDbModel::Owner.by_name('Suomi SBR') }
  let(:workbooks) { DpmYtiMapping::TypedDomains.generate_workbooks(owner) }

  it 'should produce total 1 workbook' do
    expect(workbooks.length).to eq(1)
  end

  context 'Workbook: typed-domains' do
    let(:workbook_name) { 'typed-domains-2018-1' }

    it 'should have 4 sheets' do
      expect_each_sheet(workbooks, workbook_name, 4) do |sheet, index|
        expect(sheet).to be_an_instance_of(WorkbookModel::SheetData)

        case index
        when 0
          expect(sheet.sheet_name).to eq('CodeSchemes')
        when 1
          expect(sheet.sheet_name).to eq('Codes')
        when 2
          expect(sheet.sheet_name).to eq('Extensions')
        when 3
          expect(sheet.sheet_name).to eq('Members_dpmTypedDomain')
        end
      end
    end

    it 'Sheet 1/4: CodeSchemes' do
      expect_each_row(workbooks, workbook_name, 'CodeSchemes', 1) do |row, index|
        expect(row).to be_an_instance_of(Hash)

        case index
        when 0
          expect(row[:ID].length).to eq(36)
          expect(row[:INFORMATIONDOMAIN]).to eq('P14')
          expect(row[:LANGUAGECODE]).to eq('fi;sv;en')
          expect(row[:STATUS]).to eq('DRAFT')
          expect(row[:CODEVALUE]).to eq('typ-doms-2018-1')
          expect(row[:DEFAULTCODE]).to be_nil
          expect(row[:PREFLABEL_FI]).to eq('Typed Domains 2018-1')
          expect(row[:PREFLABEL_EN]).to be_nil
          expect(row[:DESCRIPTION_FI]).to start_with('Lista Typed Domaineista')
          expect(row[:DESCRIPTION_EN]).to be_nil
          expect(row[:STARTDATE]).to be_nil
          expect(row[:ENDDATE]).to be_nil
          expect(row[:CODESSHEET]).to eq('Codes')
          expect(row[:EXTENSIONSSHEET]).to eq('Extensions')

          expect(row.length).to eq(14)
        end
      end
    end

    it 'Sheet 2/4: Codes' do
      expect_each_row(workbooks, workbook_name, 'Codes', 8) do |row, index|
        expect(row).to be_an_instance_of(Hash)

        case index
        when 0
          expect(row[:ID].length).to eq(36)
          expect(row[:STATUS]).to eq('DRAFT')
          expect(row[:CODEVALUE]).to eq('DOMT')
          expect(row[:BROADER]).to be_nil
          expect(row[:PREFLABEL_FI]).to eq('Typed domain (fi, label)')
          expect(row[:PREFLABEL_EN]).to be_nil
          expect(row[:DESCRIPTION_FI]).to eq('Typed domain (fi, description)')
          expect(row[:DESCRIPTION_EN]).to be_nil
          expect(row[:STARTDATE]).to eq('2018-10-31') # DM issue: date is written wrongly to DB
          expect(row[:ENDDATE]).to be_nil
          expect(row.length).to eq(10)

        when 1
          expect(row[:ID].length).to eq(36)
          expect(row[:STATUS]).to eq('DRAFT')
          expect(row[:CODEVALUE]).to eq('TDB')
          expect(row[:BROADER]).to be_nil
          expect(row[:PREFLABEL_FI]).to eq('Typed domain (Boolean)')
          expect(row[:PREFLABEL_EN]).to be_nil
          expect(row[:DESCRIPTION_FI]).to eq('')
          expect(row[:DESCRIPTION_EN]).to be_nil
          expect(row[:STARTDATE]).to eq('2018-10-31') # DM issue: date is written wrongly to DB
          expect(row[:ENDDATE]).to be_nil
          expect(row.length).to eq(10)

        when 2
          expect(row[:PREFLABEL_FI]).to eq('Typed domain (Date)')
          expect(row[:CODEVALUE]).to eq('TDD')

        when 3
          expect(row[:PREFLABEL_FI]).to eq('Typed domain (Integer)')
          expect(row[:CODEVALUE]).to eq('TDI')

        when 4
          expect(row[:PREFLABEL_FI]).to eq('Typed domain (Monetary)')
          expect(row[:CODEVALUE]).to eq('TDM')

        when 5
          expect(row[:PREFLABEL_FI]).to eq('Typed domain (Percentage)')
          expect(row[:CODEVALUE]).to eq('TDP')

        when 6
          expect(row[:PREFLABEL_FI]).to eq('Typed domain (Decimal)')
          expect(row[:CODEVALUE]).to eq('TDR')

        when 7
          expect(row[:PREFLABEL_FI]).to eq('Typed domain (String)')
          expect(row[:CODEVALUE]).to eq('TDS')

        end
      end
    end

    it 'Sheet 3/4: Extensions' do
      expect_each_row(workbooks, workbook_name, 'Extensions', 1) do |row, index|
        expect(row).to be_an_instance_of(Hash)

        case index
        when 0
          expect(row[:ID].length).to eq(36)
          expect(row[:CODEVALUE]).to eq('dpmTypedDomain')
          expect(row[:STATUS]).to eq('DRAFT')
          expect(row[:PROPERTYTYPE]).to eq('dpmTypedDomain')
          expect(row[:PREFLABEL_FI]).to be_nil
          expect(row[:PREFLABEL_EN]).to be_nil
          expect(row[:STARTDATE]).to be_nil
          expect(row[:ENDDATE]).to be_nil
          expect(row[:MEMBERSSHEET]).to eq('Members_dpmTypedDomain')
          expect(row.length).to eq(9)
        end
      end
    end

    it 'Sheet 4/4: Members_dpmTypedDomain' do
      expect_each_row(workbooks, workbook_name, 'Members_dpmTypedDomain', 8) do |row, index|
        expect(row).to be_an_instance_of(Hash)

        case index
        when 0
          expect(row[:ID].length).to eq(36)
          expect(row[:CODE]).to eq('DOMT')
          expect(row[:DPMDATATYPE]).to eq('boolean')
          expect(row.length).to eq(3)

        when 1
          expect(row[:CODE]).to eq('TDB')
          expect(row[:DPMDATATYPE]).to eq('boolean')

        when 2
          expect(row[:CODE]).to eq('TDD')
          expect(row[:DPMDATATYPE]).to eq('date')

        when 3
          expect(row[:CODE]).to eq('TDI')
          expect(row[:DPMDATATYPE]).to eq('integer')

        when 4
          expect(row[:CODE]).to eq('TDM')
          expect(row[:DPMDATATYPE]).to eq('monetary')

        when 5
          expect(row[:CODE]).to eq('TDP')
          expect(row[:DPMDATATYPE]).to eq('percent')

        when 6
          expect(row[:CODE]).to eq('TDR')
          expect(row[:DPMDATATYPE]).to eq('decimal')

        when 7
          expect(row[:CODE]).to eq('TDS')
          expect(row[:DPMDATATYPE]).to eq('string')
        end
      end
    end
  end
end
