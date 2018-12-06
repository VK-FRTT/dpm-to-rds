require 'rspec'

RSpec.describe DpmYtiMapping::Dimensions do

  let(:owner) { DpmDbModel::Owner.by_name('Suomi SBR') }
  let(:workbooks) { DpmYtiMapping::Dimensions.generate_workbooks(owner) }

  it 'should produce total 2 workbooks' do
    expect(workbooks.length).to eq(2)
  end

  context 'Workbook: explicit-dimensions' do
    let(:workbook_name) { 'explicit-dimensions-2018-1' }

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
          expect(sheet.sheet_name).to eq('Members_dpmDimension')
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
          expect(row[:CODEVALUE]).to eq('exp-dims-2018-1')
          expect(row[:DEFAULTCODE]).to be_nil
          expect(row[:PREFLABEL_FI]).to eq('Explicit Dimensions 2018-1')
          expect(row[:PREFLABEL_EN]).to be_nil
          expect(row[:DESCRIPTION_FI]).to start_with('Lista Explicit Dimensioista')
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
      expect_each_row(workbooks, workbook_name, 'Codes', 1 + 3) do |row, index|
        expect(row).to be_an_instance_of(Hash)

        case index
        when 0
          expect(row[:ID].length).to eq(36)
          expect(row[:STATUS]).to eq('DRAFT')
          expect(row[:CODEVALUE]).to eq('DIM')
          expect(row[:BROADER]).to be_nil
          expect(row[:PREFLABEL_FI]).to eq('Dimension (fi, label)')
          expect(row[:PREFLABEL_EN]).to be_nil
          expect(row[:DESCRIPTION_FI]).to eq('Dimension (fi, description)')
          expect(row[:DESCRIPTION_EN]).to be_nil
          expect(row[:STARTDATE]).to eq('2018-10-31') # DM issue: date is written wrongly to DB
          expect(row[:ENDDATE]).to be_nil
          expect(row.length).to eq(10)

        when 1
          expect(row[:CODEVALUE]).to eq('EDA-D1')

        when 2
          expect(row[:CODEVALUE]).to eq('EDA-D2')

        when 3
        expect(row[:CODEVALUE]).to eq('EDA-D10')

        end
      end
    end

    it 'Sheet 3/4: Extensions' do
      expect_each_row(workbooks, workbook_name, 'Extensions', 1) do |row, index|
        expect(row).to be_an_instance_of(Hash)

        case index
        when 0
          expect(row[:ID].length).to eq(36)
          expect(row[:CODEVALUE]).to eq('dpmDimension')
          expect(row[:STATUS]).to eq('DRAFT')
          expect(row[:PROPERTYTYPE]).to eq('dpmDimension')
          expect(row[:PREFLABEL_FI]).to be_nil
          expect(row[:PREFLABEL_EN]).to be_nil
          expect(row[:STARTDATE]).to be_nil
          expect(row[:ENDDATE]).to be_nil
          expect(row[:MEMBERSSHEET]).to eq('Members_dpmDimension')
          expect(row.length).to eq(9)
        end
      end
    end

    it 'Sheet 4/4: Members_dpmDimension' do
      expect_each_row(workbooks, workbook_name, 'Members_dpmDimension', 1 + 3) do |row, index|
        expect(row).to be_an_instance_of(Hash)

        case index
        when 0
          expect(row[:ID].length).to eq(36)
          expect(row[:CODE]).to eq('DIM')
          expect(row[:DPMDOMAINREFERENCE]).to eq('DOME')
          expect(row.length).to eq(3)

        when 1
          expect(row[:CODE]).to eq('EDA-D1')
          expect(row[:DPMDOMAINREFERENCE]).to eq('EDA')

        when 2
          expect(row[:CODE]).to eq('EDA-D2')
          expect(row[:DPMDOMAINREFERENCE]).to eq('EDA')

        when 2
          expect(row[:CODE]).to eq('EDA-D10')
          expect(row[:DPMDOMAINREFERENCE]).to eq('EDA')

        end
      end
    end
  end

  context 'Workbook: typed-dimensions' do
    let(:workbook_name) { 'typed-dimensions-2018-1' }

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
          expect(sheet.sheet_name).to eq('Members_dpmDimension')
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
          expect(row[:CODEVALUE]).to eq('typ-dims-2018-1')
          expect(row[:DEFAULTCODE]).to be_nil
          expect(row[:PREFLABEL_FI]).to eq('Typed Dimensions 2018-1')
          expect(row[:PREFLABEL_EN]).to be_nil
          expect(row[:DESCRIPTION_FI]).to start_with('Lista Typed Dimensioista')
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
      expect_each_row(workbooks, workbook_name, 'Codes', 2) do |row, index|
        expect(row).to be_an_instance_of(Hash)

        case index
        when 0
          expect(row[:ID].length).to eq(36)
          expect(row[:STATUS]).to eq('DRAFT')
          expect(row[:CODEVALUE]).to eq('TDB-D1')
          expect(row[:BROADER]).to be_nil
          expect(row[:PREFLABEL_FI]).to eq('TDB dimension 1')
          expect(row[:PREFLABEL_EN]).to be_nil
          expect(row[:DESCRIPTION_FI]).to eq('')
          expect(row[:DESCRIPTION_EN]).to be_nil
          expect(row[:STARTDATE]).to eq('2018-10-31') # DM issue: date is written wrongly to DB
          expect(row[:ENDDATE]).to be_nil
          expect(row.length).to eq(10)

        when 1
          expect(row[:CODEVALUE]).to eq('TDB-D2')
        end
      end
    end

    it 'Sheet 3/4: Extensions' do
      expect_each_row(workbooks, workbook_name, 'Extensions', 1) do |row, index|
        expect(row).to be_an_instance_of(Hash)

        case index
        when 0
          expect(row[:ID].length).to eq(36)
          expect(row[:CODEVALUE]).to eq('dpmDimension')
          expect(row[:STATUS]).to eq('DRAFT')
          expect(row[:PROPERTYTYPE]).to eq('dpmDimension')
          expect(row[:PREFLABEL_FI]).to be_nil
          expect(row[:PREFLABEL_EN]).to be_nil
          expect(row[:STARTDATE]).to be_nil
          expect(row[:ENDDATE]).to be_nil
          expect(row[:MEMBERSSHEET]).to eq('Members_dpmDimension')
          expect(row.length).to eq(9)
        end
      end
    end

    it 'Sheet 4/4: Members_dpmDimension' do
      expect_each_row(workbooks, workbook_name, 'Members_dpmDimension', 2) do |row, index|
        expect(row).to be_an_instance_of(Hash)

        case index
        when 0
          expect(row[:ID].length).to eq(36)
          expect(row[:CODE]).to eq('TDB-D1')
          expect(row[:DPMDOMAINREFERENCE]).to eq('TDB')
          expect(row.length).to eq(3)

        when 1
          expect(row[:CODE]).to eq('TDB-D2')
          expect(row[:DPMDOMAINREFERENCE]).to eq('TDB')
        end
      end
    end
  end
end
