require 'rails_helper'

describe API::V3::UnitesLegalesController do
  it_behaves_like 'a scopable controller', :unite_legale, :siren, :nom
  it_behaves_like 'a JSON API',            :unite_legale, :siren, :nom
  it_behaves_like 'a REST API',            :unite_legale, :siren, :nom
end
