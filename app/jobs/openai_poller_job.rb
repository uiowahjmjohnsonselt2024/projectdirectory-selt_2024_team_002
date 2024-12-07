# frozen_string_literal: true

require('concurrent')
# this class polls image generation requests from the openai table
class OpenaiPollerJob < ApplicationJob
  queue_as :default
  # rubocop:disable Metrics/MethodLength
  def perform
    jobs = OpenaiEvent.limit(4)
    jobs.each do |event|
      Rails.logger.info("poller got job with worldid: #{event.world_id}, row: #{event.row}, col: #{event.col}")
      row = event.row
      col = event.col
      world = World.where(id: event.world_id).first
      promises = []
      Concurrent::Promises.future do
        Rails.logger.info("generating image for #{world.id}, row: #{row}, col: #{col}")
        promises << OpenaiWrapperHelper.create_square(row, col, world, event)
      end
      Concurrent::Promises.zip(*promises).value
    end
  end
end
# rubocop:enable Metrics/MethodLength
