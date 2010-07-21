class TreeCard::ContentLineNode < Treetop::Runtime::SyntaxNode

  # Returns the TreeCard::Attribute representing this node.
  def attribute
    TreeCard::Attribute.new(name.text_value, param_objects, value.text_value)
  end

  private

  def param_objects
    param_list.elements.map do |semicolon_and_param|
      semicolon_and_param.param.param_object
    end
  end

end
