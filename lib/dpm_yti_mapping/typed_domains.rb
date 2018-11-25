require 'securerandom'

module DpmYtiMapping

  class TypedDomains

    def self.generate_workbooks(owner)
      workbooks = []

      workbooks << log_generated_workbook(
        DpmYtiMapping::TypedDomains::TypedDomainsListWorkbook.generate_workbook(
          DpmDbModel::Domain.typed.for_owner(owner).all
        )
      )

      workbooks
    end
  end
end
