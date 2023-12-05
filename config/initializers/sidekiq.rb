# frozen_string_literal: true

require 'sidekiq'
require 'sidekiq-cron'

Sidekiq.configure_server do |config|
  config.redis = { url: 'redis://localhost:6379/0' }
  schedule_file = Rails.root.join('config', 'sidekiq_schedule.yml')
  Sidekiq.schedule = YAML.load_file(schedule_file) if File.exist?(schedule_file)
end

Sidekiq.configure_client do |config|
  config.redis = { url: 'redis://localhost:6379/0' }
end
