# this class polls image generation requests from the openai table
class OpenaiPollerJob < ApplicationJob
  queue_as :default

  def perform
    jobs = OpenaiEvent.limit(5)
    puts jobs
    puts 'shit'
  end
end
