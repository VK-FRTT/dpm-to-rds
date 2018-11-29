require 'securerandom'

module DpmYtiMapping

  class Dimensions

    def self.generate_workbooks(owner)
      workbooks = []

      workbooks << log_generated_workbook(
        DpmYtiMapping::Dimensions::DimensionsListWorkbook.generate_workbook_explicit(
          DpmDbModel::Dimension.explicit.notMet.for_owner(owner).all
        )
      )

      workbooks << log_generated_workbook(
        DpmYtiMapping::Dimensions::DimensionsListWorkbook.generate_workbook_typed(
          DpmDbModel::Dimension.typed.notMet.for_owner(owner).all
        )
      )

      workbooks
    end
  end
end
