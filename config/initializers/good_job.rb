# frozen_string_literal: true

Rails.application.configure do
  config.good_job.preserve_job_records = false # don't keep a massive job log
end
