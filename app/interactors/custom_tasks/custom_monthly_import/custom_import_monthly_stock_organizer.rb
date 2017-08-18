class CustomImportMonthlyStockOrganizer
  include Interactor::Organizer

  organize CustomImportMonthlyStock, DownloadFile, UnzipFile, CustomImportMonthlyStockCsv
end
