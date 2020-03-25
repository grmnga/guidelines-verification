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
    @persent = get_persent
  end

  def subsection_result
    @subsection_name = params[:subsection]
    url = "http://www.surgu.ru/sveden/#{params[:subsection]}"
    html = get_html_from_section(url)
    section_data = SVEDEN_ATTRIBUTES.find { |data| data[:url] == params[:subsection] }
    @section_result = get_sveden_section_result section_data
    check_section(@section_result, html)
  end

  def get_persent
    persent = {yes: 0, no: 0}
    @sveden_result_arr.each do |subsection|
      subsection[:attributes].each do |attribute|
        section_count_result = get_count attribute
        persent[:yes] += section_count_result[:yes]
        persent[:no] += section_count_result[:no]
      end
    end
    @abitur_result_arr.each do |level|
      level[:periods].first do |period|
        period[:attributes].each do |attribute|
          section_count_result = get_count attribute
          persent[:yes] += section_count_result[:yes]
          persent[:no] += section_count_result[:no]
        end
      end
    end
    persent[:yes].to_f / ( persent[:no] + persent[:yes] ) * 100
  end

  def get_count(attribute)
    persent = {yes: 0, no: 0}
    if attribute.has_children?
      attribute.children.each do |child|
        section_count_result = get_count child
        persent[:yes] += section_count_result[:yes]
        persent[:no] += section_count_result[:no]
      end
    end
    if attribute.count > 0
      persent[:yes] += 1
    else
      persent[:no] += 1
    end
    persent
  end
end
