class API::V3::EtablissementsController < ApplicationController
  include Scopable::Controller

  def index
    @results = apply_scopes(Etablissement).all

    render json: etablissement_json, status: 200 and return unless @results.empty?
    render json: etablissement_json, status: 404
  end

  # add siret to scopes and send it to #index
  def show
    request.query_parameters[:siret] = etablissements_params[:siret]
    index
  end

  private

  def etablissement_json
    EtablissementSerializer.new(@results).serialized_json
  end

  def etablissements_params
    params.permit(:siret)
  end
end
