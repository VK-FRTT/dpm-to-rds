# frozen_string_literal: true

module YtiRds
  class Constants
    INFORMATION_DOMAIN = 'P14'
    LANGUAGE_CODE = 'fi;sv;en'
    STATUS = 'DRAFT'
    VERSION_IDENTIFIER = '2018-1'

    def self.versioned_code(code)
      "#{code}-#{VERSION_IDENTIFIER}"
    end

    def self.versioned_label(label)
      "#{label} #{VERSION_IDENTIFIER}"
    end

    class ExtensionTypes
      CALCULATION_HIERARCHY = 'calculationHierarchy'
      DEFINITION_HIERARCHY = 'definitionHierarchy'
      DPM_DIMENSION = 'dpmDimension'
    end
  end
end
