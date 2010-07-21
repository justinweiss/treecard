# A VCard attribute's parameter. Just contains a key, called +name+,
# and a list of values.
class TreeCard::Param
  attr_reader :name, :values
  def initialize(name, values)
    @name = name.downcase
    @values = values
  end
end
