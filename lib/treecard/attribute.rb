# A line in the VCard file.
#
#   * +name+ is the name of the attribute, like 'fn', 'adr', etc.
#   * +param+ is a list of +TreeCard::Param+ objects, representing each
#     parameter associated with this attribute
#   * +value+ is the raw text of the attribute's value. It is up to
#     the caller to parse, if necessary.
class TreeCard::Attribute

  attr_reader :name, :params, :value
  
  def initialize(name, params, value)
    @name = name
    @params = {}
    params.each do |param|
      @params[param.name.downcase] = param
    end
    @value = value
  end
end
