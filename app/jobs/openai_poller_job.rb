# frozen_string_literal: true

# this class polls image generation requests from the openai table
class OpenaiPollerJob < ApplicationJob
  queue_as :default
  # rubocop:disable Metrics/MethodLength
  def perform(*_arg)
    jobs = OpenaiEvent.where(in_progress: false).limit(1)
    Rails.logger.info(jobs)
    jobs.each do |event|
      Rails.logger.info("poller got job with worldid: #{event.world_id}, row: #{event.row}, col: #{event.col}")
      event.in_progress = true
      event.save!
      row = event.row
      col = event.col
      world = World.where(id: event.world_id).first
      Rails.logger.info("generating image for #{world.id}, row: #{row}, col: #{col}")
      OpenaiWrapperHelper.create_square(row, col, world, event)
    end
  end
end
# rubocop:enable Metrics/MethodLength
