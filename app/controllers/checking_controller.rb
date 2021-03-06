# require 'lib/guidelines/main'
require_relative '../../lib/guidelines/main'

class CheckingController < ApplicationController
  @@url = 'http://www.surgu.ru'
  
  def index
    # byebug
    @sveden_subsections = SVEDEN_ATTRIBUTES[:'2019'].map { |subsection_name| [ subsection_name[:name], subsection_name[:url] ] }
  end

  def result
    # sveden_urls = %w( http://www.surgu.ru/sveden )
    sveden_urls = ["#{@@url}/sveden"]
    @sveden_result_arr = get_sveden_result_array params[:year]
    processing_of_sveden_section(sveden_urls, @sveden_result_arr)

    # abitur_urls = %w( http://www.surgu.ru/abitur )
    abitur_urls = ["#{@@url}/abitur"]
    @abitur_result_arr = get_abitur_result_array
    processing_of_abitur_section(abitur_urls, @abitur_result_arr)
    @persent = get_persent
    respond_to do |format|
      format.html
      # format.pdf { render pdf: generate_pdf(@client) }
    end
  end

  def subsection_result
    @subsection_name = params[:subsection]
    url = "http://www.surgu.ru/sveden/#{params[:subsection]}"
    html = get_html_from_section(url)
    if params[:year]
      year = params[:year]
    else
      year = '2019'
    end
    section_data = SVEDEN_ATTRIBUTES[year.to_sym].find { |data| data[:url] == params[:subsection] }
    @section_result = get_sveden_section_result section_data
    check_section(@section_result, html)
    @current_itemprops = start_search_hash html
  end

  def pdf_report_to_email
    pdf = Prawn::Document.new
    pdf.text "Hellow World!"
    send_data pdf.render,
              filename: "export.pdf",
              type: 'application/pdf',
              disposition: 'inline'

    recipient = 'anna_titomer@mail.ru' # укажите свой адрес!
    output = pdf.render
    MainMailer.report_email(output, recipient).deliver
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
      level[:periods].each do |period|
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
