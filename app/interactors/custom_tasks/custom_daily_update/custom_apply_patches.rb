class CustomApplyPatches < ApplyPatches
  def apply_patch_with_log_msgs(link)
    apply_patch_before_log_msg(link)

    CustomApplyPatch.new(link: link, custom_model: context.custom_model).call

    apply_patch_after_log_msg(link)
  end
end
