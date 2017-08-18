class CustomApplyPatch
  include Interactor::Organizer

  organize DownloadFile, UnzipFile, CustomApplyFrequentUpdateCsvPatch
end
