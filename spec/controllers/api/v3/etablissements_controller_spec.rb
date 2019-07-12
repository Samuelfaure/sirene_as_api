require 'rails_helper'

describe API::V3::EtablissementsController do
  it_behaves_like 'a scopable controller', :etablissement, :siret, :enseigne_1
  it_behaves_like 'a JSON API',            :etablissement, :siret, :enseigne_1
  it_behaves_like 'a REST API',            :etablissement, :siret, :enseigne_1
end
