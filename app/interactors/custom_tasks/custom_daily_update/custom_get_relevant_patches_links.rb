class CustomGetRelevantPatchesLinks < GetRelevantPatchesLinks
  around do |interactor|
    stdout_info_log 'Visiting frequent update patches distant directory'
    interactor.call

    if context.links.empty?
      stdout_success_log('No need to apply patches. Everything up-to-date.')
    else
      stdout_success_log "Found #{context.links.size} patches !
      Retrieved relevant patches links : #{context.links}"
      puts # REVIEW: ask about this line
    end
  end

  def call
    relevant_patches_relative_links =
      select_all_patches_between_(context.first_day.to_s, context.last_day.to_s)

    unless context.we_are_rebuilding_database
      if there_is_less_than_5_patches_since_last_monthly_stock
        relevant_patches_relative_links = patches_since_last_monthly_stock
      else
        relevant_patches_relative_links = get_minimum_5_patches(relevant_patches_relative_links)
      end
    end

    context.links = change_into_absolute_links(relevant_patches_relative_links)
  end

  private

  def select_all_patches_between_(first_day, last_day)
    sirene_update_and_stock_links.select do |l|
      l[:href].match(sirene_daily_update_filename_pattern)
      padded_day_number = $1
      padded_day_number && (padded_day_number >= first_day) && (padded_day_number <= last_day)
    end
  end
end
