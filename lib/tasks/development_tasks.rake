namespace :development_tasks do
  desc 'Populate custom model with custom monthly stock link'
  task :custom_import_month => :environment do
    CustomImportMonthlyStockOrganizer.call
  end

  desc 'Populate custom model with custom daily updates'
  task :custom_import_daily => :environment do
    CustomSelectAndApplyPatchesOrganizer.call
  end

  desc 'Compare two custom models'
  task :compare_databases => :environment do
    CompareDatabases.call
  end

  desc 'log check'
  task :log_check => :environment do
    CheckNatureMiseAJourLog
  end
end
