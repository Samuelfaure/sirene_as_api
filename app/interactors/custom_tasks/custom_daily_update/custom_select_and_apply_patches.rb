class CustomSelectAndApplyPatches
  include Interactor

  def call
      context.first_day = 182
      context.last_day = 212
      context.custom_model = CustomEtablissementJuneDaily
  end
end
