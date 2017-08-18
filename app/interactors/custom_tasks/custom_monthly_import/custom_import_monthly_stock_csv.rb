class CustomImportMonthlyStockCsv < ImportMonthlyStockCsv
  around do |interactor|
    stdout_info_log 'Starting csv import'
    stdout_info_log 'Computing number of rows'

    context.csv_filename = context.unzipped_files.first
    context.number_of_rows = %x(wc -l #{context.csv_filename}).split.first.to_i - 1

    stdout_success_log "Found #{context.number_of_rows} rows to import"

    stdout_info_log 'Importing rows'

    quietly do
      stdout_etablissement_count_change do
        stdout_benchmark_stats do
          interactor.call
        end
      end
    end

    puts
  end

  def call
    # context.custom_model.delete_all

    progress_bar = ProgressBar.create(
      total: context.number_of_rows,
      format: 'Progress %c/%C |%b>%i| %a %e'
    )
    SmarterCSV.process(context.csv_filename, csv_options) do |chunk|
      CustomInsertEtablissementRowsJob.new(chunk, context.custom_model).perform
      chunk.size.times { progress_bar.increment }
    end
  end

  def stdout_etablissement_count_change
    etablissement_count_before = context.custom_model.count
    yield
    etablissement_count_after = context.custom_model.count

    entries_added = etablissement_count_after - etablissement_count_before

    puts "#{entries_added} etablissements added"
  end
end
