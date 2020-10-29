def create_attribute_object(values)
  Attribute.new(values[:value], values[:description])
end

def create_attribute_objects_array(attributes)
  attributes_obj_arr = []
  attributes.each do |attribute|
    attr_obj = create_attribute_object attribute
    if attribute[:children]
      attribute[:children].each do |child|
        attr_obj.children << create_attribute_object(child)
      end
    end
    attributes_obj_arr << attr_obj
  end
  attributes_obj_arr
end

def get_abitur_result_array
  section_abitur_result = []
  ABITUR_ATTRIBUTES.each do |level|
    level_info = {}
    level_info[:url] = level[:url]
    level_info[:level] = level[:level]
    level_info[:periods] = []
    level[:periods].each do |period|
      result_period = {}
      result_period[:when] = period[:when]
      result_period[:attributes] = create_attribute_objects_array period[:attributes]
      level_info[:periods] << result_period
    end
    section_abitur_result << level_info
  end
  section_abitur_result
end

def colorize(text, color_code)
  "\e[#{color_code}m#{text}\e[0m"
end

def red(text); colorize(text, 31); end

def get_sveden_result_array(year)
  year ||= '2019'
  # section_sveden_result = []
  # load_time_1 = Benchmark.measure do
  #   # byebug
  #   threads = []
  #   for section in SVEDEN_ATTRIBUTES[year.to_sym]
  #     threads << Thread.new(section) do |section|
  #       section_info = {}
  #       section_info[:url] = section[:url]
  #       section_info[:name] = section[:name]
  #       section_info[:attributes] = create_attribute_objects_array section[:attributes]
  #       section_sveden_result << section_info
  #     end
  #   end
  #   threads.each {|thr| thr.join }
  # end

  section_sveden_result = []
  SVEDEN_ATTRIBUTES[year.to_sym].each do |section|
    section_info = {}
    section_info[:url] = section[:url]
    section_info[:name] = section[:name]
    section_info[:attributes] = create_attribute_objects_array section[:attributes]
    section_sveden_result << section_info
  end

  # puts red '================================================'
  # puts "Load time 1 is #{load_time_1}, load time 2 is #{load_time_2}"
  # puts red '================================================'
  section_sveden_result
end

def get_sveden_section_result section
  section_info = {}
  section_info[:url] = section[:url]
  section_info[:name] = section[:name]
  section_info[:attributes] = create_attribute_objects_array section[:attributes]
  section_info
end


def search_hash(node, tags, parent = nil)
  if node.attribute('itemprop')
    if tags[node.attribute('itemprop').value]
      new_tag = Tag.new(node)
      new_tag.parent = parent
      tags[node.attribute('itemprop').value] << new_tag
    else
      tags[node.attribute('itemprop').value] = []
      new_tag = Tag.new(node)
      new_tag.parent = parent
      tags[node.attribute('itemprop').value] << new_tag
    end
    if node.children
      node.children.each do |child|
        search_hash(child, tags[node.attribute('itemprop').value].last.children, tags[node.attribute('itemprop').value].last)
      end
    end
  else
    if node.children
      node.children.each do |child|
        search_hash(child, tags, parent)
      end
    end
  end
end

# Начинаем поиск атрибутов на странице и подсчитываем количество корневых атрибутов
def start_search_hash(node)
  tags = Hash.new
  search_hash(node, tags)
  tags
end

def print_tags_tree(tree)
  tree.each do |value, brunch|
    brunch.each { |tag| tag.print_tag_hash }
  end
end

def check_attribs(tags, attributes)
  # byebug
  tags.each do |root_tag_name, root_tag_arr|
    root_tag_arr.each do |root_tag|
      attr_obj = attributes.find { |attr| attr.name == root_tag.to_s }
      # puts attr_obj.name if attr_obj
      if attr_obj
        attr_obj.count += 1
        if root_tag.has_children?
          check_attribs(root_tag.children, attributes)
          if attr_obj.has_children?
            check_attribs(root_tag.children, attr_obj.children)
            # puts "#{root_tag.to_s} has children"
            # root_tag.children.each do |itemprop, children_tags|
            #   children_attribs = attr_obj.children.find { |child| child.name == itemprop }
            #   if children_attribs
            #     children_attribs.count += children_tags.length
            #     # puts "#{children_attribs.name}: #{children_attribs.count}"
            #   end
            # end
          # else
          #   check_attribs(root_tag.children, attributes)
          end
        end
      elsif root_tag.has_children?
        check_attribs(root_tag.children, attributes)
      end
    end
  end
end