# frozen_string_literal: true

module DpmDbModel

  class ConceptTranslation < Sequel::Model(:mConceptTranslation)
    many_to_one :language, class: 'DpmDbModel::Language', key: :LanguageID, primary_key: :LanguageID, read_only: true
  end
end
