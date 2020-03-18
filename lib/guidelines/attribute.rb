class Attribute
  attr_accessor :name, :parent, :count, :children, :description

  def initialize(name, description = '')
    self.name = name.to_s
    self.description = description
    self.count = 0
    self.children = []
  end

  def add_children(name)
    children << Attribute.new(name)
  end

  def show_children
    children.each { |child| print "#{child} "}
  end

  def plus_one
    self.count += 1
  end

  def has_children?
    !children.empty?
  end

  def to_s
    "#{name}: #{count} - #{description}"
  end

  def tr(class_name)
    str = " class='#{class_name}"
    str += ' not-found' if count == 0
    str += "'"
    "<tr" + str + "><td>#{name}</td><td>#{count}</td><td>#{description}</td></tr>"
  end
end