# require 'lib/guidelines/main'
require_relative '../../lib/guidelines/main'

class CheckingController < ApplicationController
  def index
    @sveden_subsections = SVEDEN_ATTRIBUTES.map { |subsection_name| [ subsection_name[:name], subsection_name[:url] ] }
  end

  def result
    sveden_urls = %w( http://www.surgu.ru/sveden )
    @sveden_result_arr = get_sveden_result_array
    processing_of_sveden_section(sveden_urls, @sveden_result_arr)

    abitur_urls = %w( http://www.surgu.ru/abitur )
    @abitur_result_arr = get_abitur_result_array
    processing_of_abitur_section(abitur_urls, @abitur_result_arr)
  end

  def subsection_result
    @subsection_name = params[:subsection]
    url = "http://www.surgu.ru/sveden/#{params[:subsection]}"
    html = get_html_from_section(url)
    section_data = SVEDEN_ATTRIBUTES.find { |data| data[:url] == params[:subsection] }
    @section_result = get_sveden_section_result section_data
    check_section(@section_result, html)
  end
end
