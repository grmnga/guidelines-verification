class Tag
  attr_accessor :itemprop, :body, :parent, :children, :valid, :current_parent

  def initialize(body)
    raise 'There is no body!' if !body
    self.body = body
    self.itemprop = body.attribute('itemprop').value if body.attribute('itemprop').to_s
    self.valid = false
    self.children = {}
    if body.methods.include? :parent
      self.current_parent = body.parent
    else
      self.current_parent = false
    end
  end

  def is_valid?
    valid
  end

  def add_child(node)
    self.children << node
  end

  def print_tag(level = 0)
    level.times { print '| ' }
    puts "#{itemprop} "
    if has_children?
      children.each do |child|
        child.print_tag(level + 1)
      end
    end
  end

  def print_tag_hash(level = 0)
    level.times { print '| ' }
    # print "#{parent} -> "
    puts "#{itemprop} "
    if has_children?
      children.each do |key, children_arr|
        count = "#{children_arr.length}"
        print count.center(6)
        # Если у первого ребенка нет своих детей, а у последующих есть, то мы о них не узнаем...
        children_arr.first.print_tag_hash(level + 1)
      end
    end
  end

  def has_children?
    !children.empty?
  end

  def to_s
    itemprop
  end
end