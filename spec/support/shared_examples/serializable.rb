require 'rails_helper'

shared_examples 'serializable model' do |model, model_serializer, field_1|
  let(:result) { model.new(field_1 => 'Foo') }

  subject { model_serializer.new(result).serialized_json }

  it 'returns a blueprint' do
    expect(subject).to look_like_json
  end

  it 'returns the right results' do
    expect(subject_json['data']['attributes'][field_1.to_s]).to eq('Foo')
  end
end
