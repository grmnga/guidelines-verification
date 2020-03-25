require 'open-uri'
require 'nokogiri'
require_relative '../../lib/guidelines/tag'
require_relative '../../lib/guidelines/attribute'
require_relative '../../lib/guidelines/sveden_data'
require_relative '../../lib/guidelines/abitur_data'
require_relative '../../lib/guidelines/checking_methods'

def get_html_from_section(url)
  begin
    content = open(url)
    html = Nokogiri::HTML(content)
  rescue getHtmlFromSectionError
    "Не удается получить страницу подраздела #{url}"
  end
  html
end

def check_section(array_for_result, html)
  if html
    tags_with_itemprop = start_search_hash html
    check_attribs(tags_with_itemprop, array_for_result[:attributes])
  end
end


def processing_of_sveden_section(urls, result_arr)
  urls.each do |university_url|
    result_arr.each do |section|
      begin
        # Для каждого url открываем соединение и пытаемся получить html-код страницы
        content = open("#{university_url}/#{section[:url]}")
        html = Nokogiri::HTML(content)
      rescue
      end
      if html
        tags_with_itemprop = start_search_hash html
        check_attribs(tags_with_itemprop, section[:attributes])
      end
    end
  end
end

def processing_of_abitur_section(urls, result_arr)
  urls.each do |university_url|
    result_arr.each do |level|
      begin
        # Для каждого url открываем соединение и пытаемся получить html-код страницы
        content = open("#{university_url}/#{level[:url]}")
        html = Nokogiri::HTML(content)
        # file.write "<tr><td colspan='3' class='url-check-true'>#{university_url}/#{level[:url]} is OK</td></tr>"
      rescue
        # file.write "<tr><td colspan='3' class='url-check-false'>#{university_url}/#{level[:url]} doesn't available</td></tr>"
      end
      if html
        tags_with_itemprop = start_search_hash html
        level[:periods].each do |period|
          check_attribs(tags_with_itemprop, period[:attributes])
        end
      end
    end
  end
end