require 'securerandom'

module DpmYtiMapping

  class Metrics

    def self.generate_workbooks(owner)
      workbooks = []

      workbooks << log_generated_workbook(
        DpmYtiMapping::Metrics::MetricsListWorkbook.generate_workbook(
          DpmDbModel::Metric.for_owner(owner).all_sorted_naturally_by_member_code_number
        )
      )

      workbooks
    end
  end
end
