class CustomApplyFrequentUpdateCsvPatch < ApplyFrequentUpdateCsvPatch
  around do |interactor|
    stdout_info_log 'Starting csv patch update'
    stdout_info_log 'Computing number of rows'

    context.csv_filename = context.unzipped_files.first
    context.number_of_rows = %x(wc -l #{context.csv_filename}).split.first.to_i - 1

    stdout_success_log "Found #{context.number_of_rows} rows in patch"

    stdout_info_log 'Updating rows'

    quietly do
      stdout_benchmark_stats do
        interactor.call
      end
    end

    puts
  end

  def call
    progress_bar = ProgressBar.create(
      total: context.number_of_rows,
      format: 'Progress %c/%C |%b>%i| %a %e'
    )

    SmarterCSV.process(context.csv_filename, csv_options) do |chunk|
      CustomUpdateEtablissementRowsJob.new(chunk, context.custom_model).perform
      chunk.size.times { progress_bar.increment }
    end
  end
end
