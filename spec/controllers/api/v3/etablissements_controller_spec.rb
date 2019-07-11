require 'rails_helper'

describe API::V3::EtablissementsController do
  it_behaves_like 'scopable', :etablissement, :siret, :enseigne_1
  it_behaves_like 'serializable', :etablissement, :enseigne_1
end
