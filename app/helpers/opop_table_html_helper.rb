module OpopTableHtmlHelper
  def level_name_by_prefix(prefix)
    case prefix
    when 'bsm' then 'Бакалавриат, Специалитет, Магистратура'
    else
      'Уровень не определен'
    end
  end
end