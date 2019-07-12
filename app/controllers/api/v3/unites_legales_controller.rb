class API::V3::UnitesLegalesController < ApplicationController
  include Scopable::Controller

  # TODO: Add param for custom mapping on Solr,
  # Add param for fullText value
  def index
    @results = apply_scopes(UniteLegale).all

    render json: unite_legale_json, status: 200 and return unless @results.empty?
    render json: unite_legale_json, status: 404
  end

  # add siret to scopes and send it to #index
  def show
    request.query_parameters[:siren] = unite_legale_params[:siren]
    index
  end

  private

  def unite_legale_json
    UniteLegaleSerializer.new(@results).serialized_json
  end

  def unite_legale_params
    params.permit(:siren)
  end
end
