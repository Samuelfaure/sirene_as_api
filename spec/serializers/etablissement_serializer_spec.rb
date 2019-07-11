require 'rails_helper'

describe EtablissementSerializer do
  it_behaves_like 'serializable model', Etablissement, EtablissementSerializer, :enseigne_1
end