require_relative '../../lib/generator/generate_bsm'

class GenerateTableJob < ApplicationJob
  queue_as :default

  def perform()
    puts 'should start bsm'
    GenerateBsmTable.start
    GenerateTableJob.set(wait: 5.minutes).perform_later
  end
end

# GenerateTableJob.perform_later