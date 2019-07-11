class UniteLegaleSerializer < ApplicationSerializer
  @model = UniteLegale

  attributes *all_fields

  has_many :etablissements
end
