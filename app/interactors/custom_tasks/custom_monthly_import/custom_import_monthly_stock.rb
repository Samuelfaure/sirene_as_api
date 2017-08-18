class CustomImportMonthlyStock
  include Interactor

  def call
      context.link = 'http://files.data.gouv.fr/sirene/sirene_201706_L_M.zip'
      context.custom_model = CustomEtablissementJuneDaily
  end
end
