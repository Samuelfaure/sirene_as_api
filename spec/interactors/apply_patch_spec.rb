require 'rails_helper'

describe ApplyPatch do
  use_database_cleaner

  context 'when a patch must be applied' do
    let!(:etablissement) { create(:etablissement, date_mise_a_jour: '2017-04-01T01:01:01') }
    let(:patch_link) { 'spec/fixtures/sample_patches/sirene_2017095_E_Q.zip' }
    let(:last_update_before_applypatch) { Etablissement.latest_mise_a_jour }
    let(:last_update_after_applypatch) { '2017-04-05T10:43:54' }

    before do
      ApplyPatch.new(link: patch_link).call
    end

    it 'apply correctly the patch' do
      expect(last_update_before_applypatch).to eq(last_update_after_applypatch)
    end
  end
end
