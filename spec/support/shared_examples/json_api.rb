require 'rails_helper'

shared_examples 'a JSON API' do |model, field_1, field_2|
  let!(:instance_1) { create(model, field_1 => '001', field_2 => 'Foo' ) }
  let!(:instance_2) { create(model, field_1 => '002', field_2 => 'Foo' ) }
  let!(:instance_3) { create(model, field_1 => '003', field_2 => 'Bar' ) }

  describe '#index', type: :request do
    let(:route) { "/v3/#{model.to_s.pluralize}" }

    it 'match the JSON:API schema' do
      get "#{route}"

      list_errors = diff_with_schema(response.parsed_body, model)
      expect(list_errors).to be_empty
    end
  end

  describe '#show', type: :request do
    let(:route) { "/v3/#{model.to_s.pluralize}/003" }

    it 'match the JSON:API schema' do
      get "#{route}"

      list_errors = diff_with_schema(response.parsed_body, model)
      expect(list_errors).to be_empty
    end
  end
end
