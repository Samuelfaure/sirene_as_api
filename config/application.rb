require_relative 'boot'

require 'rails'
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_view/railtie'
require 'action_cable/engine'
require 'rails/test_unit/railtie'

Bundler.require(*Rails.groups)

module SireneAsAPI
  class Application < Rails::Application
    config.api_only = true
    config.active_record.schema_format = :sql

    # Background tasks
    config.active_job.queue_adapter = :resque
    config.autoload_paths += %W(#{config.root}/lib #{config.root}/app/interactors/ #{config.root}/app/services
    #{config.root}/app/interactors/custom_tasks/
    #{config.root}/app/interactors/custom_tasks/custom_daily_update
    #{config.root}/app/interactors/custom_tasks/custom_monthly_import) end
end
