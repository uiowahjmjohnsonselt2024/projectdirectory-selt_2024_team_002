# frozen_string_literal: true

Rails.application.configure do
  config.good_job.preserve_job_records = false # don't keep a massive job log
  config.execution_mode = :async
  config.max_threads = 10
  config.poll_interval = 30
end
