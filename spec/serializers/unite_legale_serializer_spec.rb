require 'rails_helper'

describe UniteLegaleSerializer do
  it_behaves_like 'serializable model', UniteLegale, UniteLegaleSerializer, :nom
end