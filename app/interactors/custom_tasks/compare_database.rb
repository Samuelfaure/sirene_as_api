require 'logger'

class CompareDatabases < SireneAsAPIInteractor
  def call
    # @maximum_entries_to_check = 10_000
    @database_from = CustomEtablissementJuneDaily
    @database_to = CustomEtablissementJuly

    create_log_files
    stdout_info_log("Starting comparison...")

    all_sirets = compare_and_get_siret_array

    progress_bar = ProgressBar.create(
      total: all_sirets.size,
      format: 'Progress %c/%C |%b>%i| %a %e'
    )

    # stdout_warn_log("Warning: Script will run only on first #{@maximum_entries_to_check} entries")
    quietly do
      all_sirets.each do |siret|
        compare_rows(siret)
        progress_bar.increment
      end
    end

    make_final_count
  end

  def stdout_info_log(msg)
    save_both_general_logs(msg)
    super
  end

  def stdout_warn_log(msg)
    save_both_general_logs(msg)
    super
  end

  def compare_and_get_siret_array
    stdout_info_log("Extracting sirets...")
    siret_array_first_database = @database_from.pluck(:siret)
    siret_array_second_database = @database_to.pluck(:siret)

    stdout_info_log("Sorted arrays. Comparing...")
    length_database_from = siret_array_first_database.length
    length_database_to = siret_array_second_database.length

    stdout_info_log("Length array #{@database_from}: #{length_database_from}")
    stdout_info_log("Length array #{@database_to}: #{length_database_to}")

    if (length_database_from > length_database_to)
      return siret_array_first_database
    else
      return siret_array_second_database
    end
  end

  def create_log_files
    file = File.open('log/comparison_database_general.txt', 'w')
    file2 = File.open('log/comparison_database_general_light.txt', 'w')

    @general_log = Logger.new(file)
    @general_log_light = Logger.new(file2)

    keys_to_save.each do |key_name|
      File.open("log/comparison_database_#{key_name}.txt", 'w')
    end
  end

  def save_both_general_logs(msg)
    @general_log.info(msg)
    @general_log_light.info(msg)
  end

  def compare_rows(siret)
    etablissement_first = @database_from.where(siret: siret).first
    etablissement_second = @database_to.where(siret: siret).first

    if (etablissement_first == nil && etablissement_second != nil)
      save_both_general_logs("Difference found : #{@database_from} doesn't exist but #{@database_to} does for siret : #{siret}")

    elsif (etablissement_first != nil && etablissement_second == nil)
      save_both_general_logs("Difference found : #{@database_from} exist but #{@database_to} doesn't for siret : #{siret}")

    elsif (etablissement_first == nil && etablissement_second == nil)
      save_both_general_logs("A siret with no name in both databases was found : #{siret}")

    else
      first_hash_purged = etablissement_first.attributes.except(*keys_to_remove)
      second_hash_purged = etablissement_second.attributes.except(*keys_to_remove)

      diff = get_differences_between_hashes(first_hash_purged, second_hash_purged)
      # values_diff = diff.flatten

      if diff
        @general_log.info("Siret #{siret}- DIFFERENCE FOUND - #{diff}")
        save_in_correct_log(diff, siret)
      end
    end
  end

    def save_in_correct_log(diff, siret)
      keys_to_save.each do |key_name|
        #check if contains the string with double quotes to avoid mixing names like nom and nom_raison_sociale
        if (diff.first.include? "\"#{key_name}\"")
          File.open("log/comparison_database_#{key_name}.txt", "a") do |f|
            f.puts "Siret #{siret} - DIFFERENCE FOUND - #{diff}"
          end
        end
      end
    end

  def get_differences_between_hashes(hash1, hash2)
    differenceA = hash2.to_a - hash1.to_a
    differenceB = hash1.to_a - hash2.to_a
    [differenceA, differenceB].flatten.empty? ? nil:["In #{@database_from}: #{differenceA}", "In #{@database_to}: #{differenceB}"]
  end

  def quietly
    ar_log_level_before_block_execution = ActiveRecord::Base.logger.level
    ActiveRecord::Base.logger.level = :fatal
    log_level_before_block_execution = Rails.logger.level
    yield
    Rails.logger.level = log_level_before_block_execution
    ActiveRecord::Base.logger.level = ar_log_level_before_block_execution
  end

  def make_final_count
    stdout_info_log("TOTAL COUNT FOR EACH DIFFERENCE")
    total_differences = 0

    keys_to_save.each do |key_name|
      lines = File.foreach("log/comparison_database_#{key_name}.txt").count
      stdout_info_log("Total differences in #{key_name} : #{lines}")
      total_differences += lines
    end

    lines = File.foreach("log/comparison_database_general.txt").count
    stdout_warn_log("Total rows that are differents : #{lines} on a total of #{@maximum_entries_to_check} checked")
    stdout_warn_log("Total differences : #{total_differences}")
  end

  def keys_to_remove
    return [
      "id",
      "created_at",
      "updated_at",
      "nature_mise_a_jour",
      "indicateur_mise_a_jour_1",
      "indicateur_mise_a_jour_2",
      "indicateur_mise_a_jour_3",
      "date_mise_a_jour",
      "type_evenement",
      "date_evenement",
      "type_creation",
      "date_reactivation_etablissement",
      "date_reactivation_entreprise",
      "indicateur_mise_a_jour_enseigne_entreprise",
      "indicateur_mise_a_jour_activite_principale_etablissement",
      "indicateur_mise_a_jour_adresse_etablissement",
      "indicateur_mise_a_jour_caractere_productif_etablissement",
      "indicateur_mise_a_jour_caractere_auxiliaire_etablissement",
      "indicateur_mise_a_jour_nom_raison_sociale",
      "indicateur_mise_a_jour_sigle",
      "indicateur_mise_a_jour_nature_juridique",
      "indicateur_mise_a_jour_activite_principale_entreprise",
      "indicateur_mise_a_jour_caractere_productif_entreprise",
      "indicateur_mise_a_jour_nic_siege",
      "siret_predecesseur_successeur"
      ]
  end

  def keys_to_save
    return [
    "siren",
    "siret",
    "nic",
    "l1_normalisee",
    "l2_normalisee",
    "l3_normalisee",
    "l4_normalisee",
    "l5_normalisee",
    "l6_normalisee",
    "l7_normalisee",
    "l1_declaree",
    "l2_declaree",
    "l3_declaree",
    "l4_declaree",
    "l5_declaree",
    "l6_declaree",
    "l7_declaree",
    "numero_voie",
    "indice_repetition",
    "type_voie",
    "libelle_voie",
    "code_postal",
    "cedex",
    "region",
    "libelle",
    "departement",
    "arrondissement",
    "canton",
    "commune",
    "libelle_commune",
    "departement_unite_urbaine",
    "taille_unite_urbaine",
    "numero_unite_urbaine",
    "etablissement_public_cooperation_intercommunale",
    "tranche_commune_detaillee",
    "zone_emploi",
    "is_siege",
    "enseigne",
    "indicateur_champ_publipostage",
    "statut_diffusion",
    "date_introduction_base_diffusion",
    "nature_entrepreneur_individuel",
    "libelle_nature_entrepreneur_individuel",
    "activite_principale",
    "libelle_activite_principale",
    "date_validite_activite_principale",
    "tranche_effectif_salarie",
    "libelle_tranche_effectif_salarie",
    "tranche_effectif_salarie_centaine_pret",
    "date_validite_effectif_salarie",
    "origine_creation",
    "date_creation",
    "date_debut_activite",
    "nature_activite",
    "lieu_activite",
    "type_magasin",
    "is_saisonnier",
    "modalite_activite_principale",
    "caractere_productif",
    "participation_particuliere_production",
    "caractere_auxiliaire",
    "nom_raison_sociale",
    "sigle",
    "nom",
    "prenom",
    "civilite",
    "numero_rna",
    "nic_siege",
    "region_siege",
    "departement_commune_siege",
    "email",
    "nature_juridique_entreprise",
    "libelle_nature_juridique_entreprise",
    "activite_principale_entreprise",
    "libelle_activite_principale_entreprise",
    "date_validite_activite_principale_entreprise",
    "activite_principale_registre_metier",
    "is_ess",
    "date_ess",
    "tranche_effectif_salarie_entreprise",
    "libelle_tranche_effectif_salarie_entreprise",
    "tranche_effectif_salarie_entreprise_centaine_pret",
    "date_validite_effectif_salarie_entreprise",
    "categorie_entreprise",
    "date_creation_entreprise",
    "date_introduction_base_diffusion_entreprise",
    "indice_monoactivite_entreprise",
    "modalite_activite_principale_entreprise",
    "caractere_productif_entreprise",
    "date_validite_rubrique_niveau_entreprise_esa",
    "tranche_chiffre_affaire_entreprise_esa",
    "activite_principale_entreprise_esa",
    "premiere_activite_secondaire_entreprise_esa",
    "deuxieme_activite_secondaire_entreprise_esa",
    "troisieme_activite_secondaire_entreprise_esa",
    "quatrieme_activite_secondaire_entreprise_esa"
  ]
  end
end
