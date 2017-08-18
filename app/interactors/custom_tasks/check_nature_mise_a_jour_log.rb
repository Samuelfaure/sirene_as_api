class CheckNatureMiseAJourLog
    progress_bar = ProgressBar.create(
      total: 90_000,
      format: 'Progress %c/%C |%b>%i| %a %e'
    )

    not_found = 0
    nil_mise_a_jour = 0
    isnt_found = []
    File.open('log/comparison_database_general_light.txt').each do |line|
      line_siret = line.match(/\d{14}/).to_s
      result = CustomEtablissementJuly.find_by(siret: line_siret)
      if result
        nil_mise_a_jour += 1
      else
        not_found += 1
        isnt_found << line_siret
      end
    progress_bar.increment
    end
    puts "NOT FOUND: #{not_found}"
    puts "NIL MAJ : #{nil_mise_a_jour}"
    puts isnt_found
end
