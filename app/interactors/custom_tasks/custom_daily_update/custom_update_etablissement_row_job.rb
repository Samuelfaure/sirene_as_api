class CustomUpdateEtablissementRowsJob
  attr_accessor :lines
  attr_accessor :custom_model

  def initialize(lines, custom_model)
    @lines = lines
    @model = custom_model
  end

  def perform
    etablissements = []

    for line in lines do
      etablissement_atts = EtablissementAttrsFromLine.instance.call(line)
      etablissements << etablissement_atts
    end

    etablissements.each do |etablissement_attrs|
      siret = etablissement_attrs[:siret]
      etablissement = @model.find_or_initialize_by(siret: siret)

      nature_mise_a_jour = etablissement_attrs[:nature_mise_a_jour]

      if nature_mise_a_jour == 'I'
        # Il y a une paire I/F, I étant l'état initial
        next
      elsif nature_mise_a_jour == 'E'
        # On supprime l'établissement si il est persisté
        # Si non persisté veut dire qu on rejoue un patch interrompu
        if etablissement.persisted?
          etablissement.destroy
        end

        next
      end
      etablissement.update_attributes(etablissement_attrs)
    end
  end
end
