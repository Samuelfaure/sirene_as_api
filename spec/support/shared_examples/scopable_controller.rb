shared_examples 'a scopable controller' do |model, field_1, field_2|
  describe 'filtering', type: :request do
    let!(:instance_1) { create(model, field_1 => '001', field_2 => 'Foo') }
    let!(:instance_2) { create(model, field_1 => '002', field_2 => 'Bar') }
    let!(:instance_3) { create(model, field_1 => '003', field_2 => 'Bar') }

    let(:route) { "/v3/#{model.to_s.pluralize}" }

    it 'can filter with 1 field' do
      get "#{route}?#{field_1.to_s}=001"

      expect(response_data.size).to eq(1)
      expect(response_data[0]['attributes'][field_2.to_s]).to eq('Foo')
    end

    it 'can filter with multiple fields' do
      get "#{route}?#{field_1.to_s}=001&#{field_2.to_s}=Foo"

      expect(response_data.size).to eq(1)
      expect(response_data[0]['attributes'][field_2.to_s]).to eq('Foo')
    end

    it 'can filter and return multiple results' do
      get "#{route}?#{field_2.to_s}=Bar"

      expect(response_data.size).to eq(2)
      expect(response_data[0]['attributes'][field_2.to_s]).to eq('Bar')
    end
  end
end
