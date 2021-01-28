require_relative '../../lib/generator/generate_bsm'

class GenerateTableJob < ApplicationJob
  queue_as :default

  def perform()
    puts 'should start bsm'
    GenerateBsmTable.start
    bsm_table_html = IO.read('result.html')
    if OpopTableHtml.find_by('level': 'bsm')
      bsm = OpopTableHtml.find_by('level': 'bsm')
      bsm.update('html': bsm_table_html)
    else
      OpopTableHtml.create('level': 'bsm', 'html': bsm_table_html)
    end
    GenerateTableJob.set(wait: 5.minutes).perform_later
  end
end

# GenerateTableJob.perform_later