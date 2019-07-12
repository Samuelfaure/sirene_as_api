require 'rails_helper'

shared_examples 'a REST API' do |model, field_1, field_2|
  let!(:instance_1) { create(model, field_1 => '001', field_2 => 'Foo' ) }
  let!(:instance_2) { create(model, field_1 => '002', field_2 => 'Foo' ) }
  let!(:instance_3) { create(model, field_1 => '003', field_2 => 'Bar' ) }

  describe '#index', type: :request do
    let(:route) { "/v3/#{model.to_s.pluralize}" }

    it 'returns the right data' do
      get "#{route}"

      expect(response_data[0]['attributes'][field_2.to_s]).to eq('Foo')
      expect(response_data[2]['attributes'][field_2.to_s]).to eq('Bar')
    end
  end

  describe '#show', type: :request do
    let(:route) { "/v3/#{model.to_s.pluralize}/003" }

    it 'returns one right result' do
      get "#{route}"

      expect(response_data[0]['attributes'][field_2.to_s]).to eq('Bar')
      expect(response_data[1]).to be_nil
    end
  end
end
