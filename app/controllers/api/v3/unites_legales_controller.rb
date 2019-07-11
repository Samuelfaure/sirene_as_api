class API::V3::UnitesLegalesController < ApplicationController
  include Scopable::Controller

  # TODO: Add param for custom mapping on Solr,
  # Add param for fullText value
  def index
    results = apply_scopes(UniteLegale).all

    render json: UniteLegaleSerializer.new(results).serialized_json, status: 200
  end
end
