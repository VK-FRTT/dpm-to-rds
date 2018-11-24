# frozen_string_literal: true

module DpmDbModel

  class Concept < Sequel::Model(:mConcept)
    one_to_many :translations, class: 'DpmDbModel::ConceptTranslation', key: :ConceptID, read_only: true

    def label_fi
      translated_text('label', 'fi')
    end

    def label_en
      nil
    end

    def description_fi
      translated_text('description', 'fi')
    end

    def description_en
      nil
    end

    def start_date_iso8601
      self.FromDate ? self.FromDate.iso8601 : nil
    end

    def end_date_iso8601
      self.ToDate ? self.ToDate.iso8601 : nil
    end

    private

    def translated_text(role, lang_code)
      translation = translations.find { |t| t.Role == role && t.language.IsoCode == lang_code }
      translation ? translation.Text : ''
    end
  end
end
