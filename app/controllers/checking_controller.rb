# require 'lib/guidelines/main'
require_relative '../../lib/guidelines/main'

class CheckingController < ApplicationController
  def index
  end

  def result
    sveden_urls = %w( http://www.surgu.ru/sveden )
    @sveden_result_arr = get_sveden_result_array
    processing_of_sveden_section(sveden_urls, @sveden_result_arr)

    abitur_urls = %w( http://www.surgu.ru/abitur )
    @abitur_result_arr = get_abitur_result_array
    processing_of_abitur_section(abitur_urls, @abitur_result_arr)
  end
end
