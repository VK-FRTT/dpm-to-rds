require 'rspec'

RSpec.describe DpmYtiMapping::ExplicitDomainsAndHierarchies do

  let(:owner) { DpmDbModel::Owner.by_name('Suomi SBR') }
  let(:workbooks) { DpmYtiMapping::ExplicitDomainsAndHierarchies.generate_workbooks(owner) }

  context 'Workbook: explicit-domains-list' do
    let(:workbook_name) { 'explicit-domains-list-2018-1' }

    it 'Sheet: CodeSchemes' do
      expect_row_content(workbooks, workbook_name, 'CodeSchemes', 1, 0) do |row|
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

    it 'Sheet: Codes' do
      expect_row_content(workbooks, workbook_name, 'Codes', 2, 0) do |row|
        verify_code_row(row)
        expect(row[:CODEVALUE]).to eq('EDA')
        expect(row[:BROADER]).to be_nil
        expect(row[:PREFLABEL_FI]).to eq 'Explicit domain A'
        expect(row[:PREFLABEL_EN]).to eq ''
        expect(row[:DESCRIPTION_FI]).to eq ''
        expect(row[:DESCRIPTION_EN]).to eq ''
        expect(row[:STARTDATE]).to eq '2018-10-31'
        expect(row[:ENDDATE]).to be_nil
        expect(row[:SHORTNAME].length).to be > 10
        expect(row.length).to be(11)
      end
    end
  end


end