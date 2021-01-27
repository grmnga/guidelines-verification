require 'open-uri'
require 'nokogiri'
require_relative 'generate_opop_table'
require_relative 'programs'

module GenerateBsmTable
  extend GenerateOpopTable
  include Programs

  @main_url = 'http://publish.surgu.ru/bsm/'
  @result = {}

  def self.func(program_tag)
    program_relative_path = href(program_tag)
    program_code = program_relative_path.delete('/')
    # return if program_code != '49.03.02'
    @result[program_code.to_s] = {}
    return if %w(current last).include? program_code
    puts "loading #{program_code} #{COMMON_INFO[program_code][:name]} #{COMMON_INFO[program_code][:level]}"
    url = @main_url + program_relative_path + '1/'

    # вытаскиваем ссылки на профили
    profiles_link_tags = get_links_list url
    profiles_link_tags.each do |profile_tag|
      profile_relative_path = href(profile_tag)
      profile_name = decode(profile_tag).delete('/')
      # next if profile_name != 'Адаптированная образовательная программа "Адаптивное физическое воспитание"'
      @result[program_code.to_s][profile_name.to_s] = {}

      # получаем полный адрес на профиль
      profile_url = url + profile_relative_path

      # вытаскиваем ссылки на ФГОСы
      fgoses_link_tags = get_links_list profile_url
      fgoses_link_tags.each do |fgos|
        fgos_name = decode(fgos).delete('/')

        # получаем полный адрес каталога с ФГОСом
        fgos_url = profile_url + href(fgos)

        uri = URI.escape('3 УЧЕБНЫЕ ПЛАНЫ/')
        up_url = fgos_url+ uri

        # получаем полный список учебных планов по текущему ФГОСу
        up_link_tags = get_links_list up_url
        up_link_tags.each do |edu_plan|
          up_file_name = decode(edu_plan)
          FORMS.keys.each do |form|
            if up_file_name.index(form)
              @result[program_code.to_s][profile_name.to_s][form] ||= {}
              %w(2015 2016 2017 2018 2019 2020).each do |year|
                if up_file_name.index(year)
                  @result[program_code.to_s][profile_name.to_s][form][year] = {}

                  current_plan_url = up_url + href(edu_plan)
                  @result[program_code.to_s][profile_name.to_s][form][year][:edu_plan_link] = current_plan_url

                  set_values(@result[program_code.to_s][profile_name.to_s][form][year],
                             fgos_url,
                             program_code,
                             profile_name,
                             { fgos: fgos_name,
                               form: form,
                               year: year })
                end
              end
            end
          end
        end
      end
    end
    # p @result
  end

  def self.start
    # puts count = COMMON_INFO.select { |k, v| [LEVELS[1], LEVELS[2], LEVELS[3]].include? v[:level] }.count
    initial_log_file
    programs_link_tags = get_links_list @main_url
    threads = []
    programs_link_tags.each do |program_tag|
      threads << Thread.new(program_tag) do |program_tag|
        self.func program_tag
      end
    end
    threads.each {|thr| thr.join }
    generate_table
  end
end