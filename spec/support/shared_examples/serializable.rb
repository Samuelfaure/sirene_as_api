require 'rails_helper'

shared_examples 'serializable' do |model, field_1|
  describe 'response format', type: :request do
    let!(:instance_1) { create(model, field_1 => 'Foo') }
    let!(:instance_2) { create(model, field_1 => 'Bar') }
    let!(:instance_3) { create(model, field_1 => 'Bar') }

    let(:route) { "/v3/#{model.to_s.pluralize}" }

    it 'match the JSON:API schema' do
      get "#{route}"

      list_errors = diff_json_schema(response.parsed_body, model)
      expect(list_errors).to be_empty
    end

    it 'returns the right results' do
      get "#{route}"

      expect(response_data[0]['attributes'][field_1.to_s]).to eq('Foo')
    end
  end
end
