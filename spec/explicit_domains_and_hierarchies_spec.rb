require 'rspec'

RSpec.describe DpmYtiMapping::ExplicitDomainsAndHierarchies do

  let(:owner) { DpmDbModel::Owner.by_name('Suomi SBR') }
  let(:workbooks) { DpmYtiMapping::ExplicitDomainsAndHierarchies.generate_workbooks(owner) }

  it 'should produce total 3 workbooks' do
    expect(workbooks.length).to eq(3)
  end

  context 'Workbook: explicit-domains-list' do
    let(:workbook_name) { 'explicit-domains-list-2018-1' }

    it 'Sheet: CodeSchemes' do
      expect_each_row(workbooks, workbook_name, 'CodeSchemes', 1) do |row, index|
        expect(row).to be_an_instance_of(Hash)

        case index
        when 0
          verify_code_scheme_row(row)
          expect(row[:CODEVALUE]).to eq('exp-doms-2018-1')
          expect(row[:DEFAULTCODE]).to be_nil
          expect(row[:PREFLABEL_FI]).to start_with 'Explicit Domains 2018-1'
          expect(row[:PREFLABEL_EN]).to be_nil
          expect(row[:DESCRIPTION_FI]).to start_with 'Lista Explicit Domaineista'
          expect(row[:DESCRIPTION_EN]).to be_nil
          expect(row[:STARTDATE]).to be_nil
          expect(row[:ENDDATE]).to be_nil
          expect(row[:EXTENSIONSSHEET]).to be_nil
          expect(row.length).to be(14)
        end
      end
    end

    it 'Sheet: Codes' do
      expect_each_row(workbooks, workbook_name, 'Codes', 2) do |row, index|
        expect(row).to be_an_instance_of(Hash)

        case index
        when 0
          verify_code_row(row)
          expect(row[:CODEVALUE]).to eq('EDA')
          expect(row[:BROADER]).to be_nil
          expect(row[:PREFLABEL_FI]).to eq 'Explicit domain A'
          expect(row[:PREFLABEL_EN]).to eq ''
          expect(row[:DESCRIPTION_FI]).to eq ''
          expect(row[:DESCRIPTION_EN]).to eq ''
          expect(row[:STARTDATE]).to eq '2018-10-31' # DM issue: date is written wrongly to DB
          expect(row[:ENDDATE]).to be_nil
          expect(row[:SHORTNAME].length).to be > 10
          expect(row.length).to be(11)

        when 1
          verify_code_row(row)
          expect(row[:CODEVALUE]).to eq('DOM')
          expect(row[:BROADER]).to be_nil
          expect(row[:PREFLABEL_FI]).to eq 'Domain (fi, label)'
          expect(row[:PREFLABEL_EN]).to eq ''
          expect(row[:DESCRIPTION_FI]).to eq 'Domain (fi, description)'
          expect(row[:DESCRIPTION_EN]).to eq ''
          expect(row[:STARTDATE]).to eq '2018-12-31' # DM issue: date is written wrongly to DB
          expect(row[:ENDDATE]).to eq '2019-05-30'
          expect(row[:SHORTNAME].length).to be > 10
          expect(row.length).to be(11)
        end
      end
    end
  end

  context 'Workbook: domain-members-and-hierarchies EDA' do
    let(:workbook_name) { 'domain-members-and-hierarchies-EDA-2018-1' }

    it 'Sheet: CodeSchemes' do
      expect_each_row(workbooks, workbook_name, 'CodeSchemes', 1) do |row, index|
        expect(row).to be_an_instance_of(Hash)

        case index
        when 0
          verify_code_scheme_row(row)
          expect(row[:CODEVALUE]).to eq('EDA-2018-1')
          expect(row[:DEFAULTCODE]).to be_nil
          expect(row[:PREFLABEL_FI]).to eq 'Explicit domain A 2018-1'
          expect(row[:PREFLABEL_EN]).to be_nil
          expect(row[:DESCRIPTION_FI]).to be_nil
          expect(row[:DESCRIPTION_EN]).to be_nil
          expect(row[:STARTDATE]).to be_nil
          expect(row[:ENDDATE]).to be_nil
          expect(row[:EXTENSIONSSHEET]).to eq 'Extensions'

          expect(row.length).to be(14)
        end
      end
    end

    it 'Sheet: Codes' do
      expect_each_row(workbooks, workbook_name, 'Codes', 12) do |row, index|
        expect(row).to be_an_instance_of(Hash)

        case index
        when 0
          verify_code_row(row)
          expect(row[:CODEVALUE]).to eq('EDA-x1')
          expect(row[:BROADER]).to be_nil
          expect(row[:PREFLABEL_FI]).to eq 'EDA member 1'
          expect(row[:PREFLABEL_EN]).to eq ''
          expect(row[:DESCRIPTION_FI]).to eq ''
          expect(row[:DESCRIPTION_EN]).to eq ''
          expect(row[:STARTDATE]).to eq '2018-10-31' # DM issue: date is written wrongly to DB
          expect(row[:ENDDATE]).to be_nil
          expect(row.length).to be(10)

        when 1
          verify_code_row(row)
          expect(row[:CODEVALUE]).to eq('EDA-x2')

        when 2
          verify_code_row(row)
          expect(row[:CODEVALUE]).to eq('EDA-x3')

        when 3
          verify_code_row(row)
          expect(row[:CODEVALUE]).to eq('EDA-x4')
          expect(row[:BROADER]).to be_nil
          expect(row[:PREFLABEL_FI]).to eq 'EDA member (=, 1)'
          expect(row[:PREFLABEL_EN]).to eq ''
          expect(row[:DESCRIPTION_FI]).to eq ''
          expect(row[:DESCRIPTION_EN]).to eq ''
          expect(row[:STARTDATE]).to eq '2018-10-31' # DM issue: date is written wrongly to DB
          expect(row[:ENDDATE]).to be_nil
          expect(row.length).to be(10)

        when 4
          verify_code_row(row)
          expect(row[:CODEVALUE]).to eq('EDA-x5')

        when 5
          verify_code_row(row)
          expect(row[:CODEVALUE]).to eq('EDA-x6')

        when 6
          verify_code_row(row)
          expect(row[:CODEVALUE]).to eq('EDA-x7')

        when 7
          verify_code_row(row)
          expect(row[:CODEVALUE]).to eq('EDA-x8')

        when 8
          verify_code_row(row)
          expect(row[:CODEVALUE]).to eq('EDA-x9')

        when 9
          verify_code_row(row)
          expect(row[:CODEVALUE]).to eq('EDA-x10')

        when 10
          verify_code_row(row)
          expect(row[:CODEVALUE]).to eq('EDA-x19')

        when 11
          verify_code_row(row)
          expect(row[:CODEVALUE]).to eq('EDA-x20')
        end
      end
    end
  end

  context 'Workbook: domain-members-and-hierarchies DOM' do
    let(:workbook_name) { 'domain-members-and-hierarchies-DOM-2018-1' }

    it 'Sheet: CodeSchemes' do
      expect_each_row(workbooks, workbook_name, 'CodeSchemes', 1) do |row, index|
        expect(row).to be_an_instance_of(Hash)

        case index
        when 0
          verify_code_scheme_row(row)
          expect(row[:CODEVALUE]).to eq('DOM-2018-1')
          expect(row[:DEFAULTCODE]).to be_nil
          expect(row[:PREFLABEL_FI]).to eq 'Domain (fi, label) 2018-1'
          expect(row[:PREFLABEL_EN]).to be_nil
          expect(row[:DESCRIPTION_FI]).to be_nil
          expect(row[:DESCRIPTION_EN]).to be_nil
          expect(row[:STARTDATE]).to be_nil
          expect(row[:ENDDATE]).to be_nil
          expect(row[:EXTENSIONSSHEET]).to eq 'Extensions'

          expect(row.length).to be(14)
        end
      end
    end

    it 'Sheet: Codes' do
      expect_each_row(workbooks, workbook_name, 'Codes', 1) do |row, index|
        expect(row).to be_an_instance_of(Hash)

        case index
        when 0
          verify_code_row(row)
          expect(row[:CODEVALUE]).to eq('MEM')
          expect(row[:BROADER]).to be_nil
          expect(row[:PREFLABEL_FI]).to eq 'Member (fi, label)'
          expect(row[:PREFLABEL_EN]).to eq ''
          expect(row[:DESCRIPTION_FI]).to eq 'Member (fi, description)'
          expect(row[:DESCRIPTION_EN]).to eq ''
          expect(row[:STARTDATE]).to eq '2018-10-31' # DM issue: date is written wrongly to DB
          expect(row[:ENDDATE]).to be_nil
          expect(row.length).to be(10)
        end
      end
    end
  end
end