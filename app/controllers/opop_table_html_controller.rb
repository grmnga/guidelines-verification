class OpopTableHtmlController < ApplicationController
  def bsm
    @info = OpopTableHtml.find_by('level': 'bsm')
  end
end
