require 'rails_helper'

shared_examples 'a REST API' do |model, field_1, field_2|
  let!(:instance_1) { create(model, field_1 => '001', field_2 => 'Foo' ) }
  let!(:instance_2) { create(model, field_1 => '002', field_2 => 'Foo' ) }
  let!(:instance_3) { create(model, field_1 => '003', field_2 => 'Bar' ) }

  subject { response }

  let(:route) { "/v3/#{model.to_s.pluralize}" }

  describe '#index', type: :request do
    context 'found' do
      before(:each) { get route }

      it 'returns the right data' do
        expect(response_data[0]['attributes'][field_2.to_s]).to eq('Foo')
        expect(response_data[2]['attributes'][field_2.to_s]).to eq('Bar')
      end

      its(:status) { is_expected.to eq(200) }
    end

    context 'not found' do
      before do
        [instance_1, instance_2, instance_3].each { |record| record.destroy }
        get route
      end

      its(:status) { is_expected.to eq(404) }
    end
  end

  describe '#show', type: :request do
    context 'found' do
      before(:each) { get "#{route}/003" }

      it 'returns one right result' do
        expect(response_data[0]['attributes'][field_2.to_s]).to eq('Bar')
        expect(response_data[1]).to be_nil
      end

      its(:status) { is_expected.to eq(200) }
    end

    context 'not found' do
      before { get "#{route}/99999" }

      its(:status) { is_expected.to eq(404) }
    end
  end
end
