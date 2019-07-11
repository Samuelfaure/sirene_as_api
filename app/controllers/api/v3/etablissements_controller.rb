class API::V3::EtablissementsController < ApplicationController
  include Scopable::Controller

  def index
    results = apply_scopes(Etablissement).all

    render json: EtablissementSerializer.new(results).serialized_json, status: 200
  end
end
