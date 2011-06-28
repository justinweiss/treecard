require 'treetop'
require 'grammar/vcard' # implements the vcard spec, found at http://tools.ietf.org/html/rfc2425

class TreeCard; end

class TreeCard::ParseError < Exception
end

require 'treecard/nodes/content_line_node'
require 'treecard/nodes/param_node'
require 'treecard/attribute'
require 'treecard/param'

class TreeCard

  attr_reader :raw_data
  attr_reader :attributes

  def initialize(data)
    @attributes = Hash.new {|h, k| h[k] = []}
    @raw_data = self.class.unfold_lines(data)
    @parser = VCardGrammarParser.new
    ast = @parser.parse(@raw_data)
    if ast
      parse(ast)
    else
      raise TreeCard::ParseError, @parser.failure_reason
    end
  end

  def name
    attr = attributes['fn']
    attr &&= attr.first
    attr.value if attr
  end

  def emails
    attr = attributes['email']
    attr.map {|email| email.value} if attr
  end

  def phone
    attr = attribute_with_param('tel', 'voice')
    attr.value if attr
  end

  def fax
    attr = attribute_with_param('tel', 'fax')
    attr.value if attr
  end

  def photo
    attr = attributes['photo']
    attr &&= attr.first
    attr.value if attr
  end

  def address
    attr = attributes['adr']
    attr &&= attr.first
    attr.value.split(';').join("\n").strip if attr
  end

  def company
    attr = attributes['org']
    attr &&= attr.first
    attr.value if attr
  end
  
  def url
    attr = attributes['url']
    attr &&= attr.first
    attr.value if attr
  end
  
  # VCards automatically wrap lines longer than 75 characters. Wrapped
  # lines are signified by leading whitespace.
  def self.unfold_lines(data)
    unfolded_data = ""
    current_line = ""
    data.lines.each do |line|
      if line =~ /^\s\S+/
        current_line << line[1..-1].chomp
      else
        if current_line != ""
          if current_line =~ /=0D=0A=$/ #weird quoted printable thing
            unfolded_data << current_line.chomp
          else
            unfolded_data << current_line + "\n"
          end
        end
        current_line = line.chomp
      end
    end
    unfolded_data << current_line + "\n"
    unfolded_data
  end

  # Returns the first attribute with +attr_name+ where +param_name+ is
  # set.
  def attribute_with_param(attr_name, param_name)
    attributes = self.attributes[attr_name.downcase]
    found_attributes = attributes.select { |attribute| attribute.params[param_name.downcase] }
    found_attributes.first
  end

  private

  def parse(root)
    root.elements.each do |contentline|
      parse_contentline(contentline)
    end
  end

  def parse_contentline(node)
    attributes[node.name.text_value.downcase] << node.attribute
  end
end
