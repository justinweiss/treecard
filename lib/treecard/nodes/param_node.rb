class TreeCard::ParamNode < Treetop::Runtime::SyntaxNode

  # Returns the TreeCard::Param object representing this node. 
  def param_object
    param_values = []
    if self.respond_to?(:param_value)
      param_values = [param_value.text_value] + extra_params.elements.map { |extra_param| extra_param.param_value.text_value }
    end
    TreeCard::Param.new(param_name.text_value, param_values)
  end
end
