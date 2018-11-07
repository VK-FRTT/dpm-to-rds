# frozen_string_literal: true

module DpmDbModel

  class Concept < Sequel::Model(:mConcept)
    one_to_many :translations, class: 'DpmDbModel::ConceptTranslation', key: :ConceptID, read_only: true

    def label_fi
      translation('label', 'fi')
    end

    def label_en
      translation('label', 'en')
    end

    def description_fi
      translation('description', 'fi')
    end

    def description_en
      translation('description', 'en')
    end

    def translation(role, lang_code)
      translations.each { |translation|
        if translation.Role == role && translation.language.IsoCode == lang_code
          return translation.Text
        end

        return nil
      }
    end
  end

end
