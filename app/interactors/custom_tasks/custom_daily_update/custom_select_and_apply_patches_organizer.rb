class CustomSelectAndApplyPatchesOrganizer < SireneAsAPIInteractor
  include Interactor::Organizer

  organize CustomSelectAndApplyPatches, CustomGetRelevantPatchesLinks, CustomApplyPatches
end
