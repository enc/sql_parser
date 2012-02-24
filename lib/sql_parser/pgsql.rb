class Statement < Treetop::Runtime::SyntaxNode
  def to_s
    command.to_sql
  end
end

class SelectStatement < Treetop::Runtime::SyntaxNode
  def to_sql
    elements.collect do |item|
      item.to_sql
    end.join("")
  end
end

class SpaceNode < Treetop::Runtime::SyntaxNode
  def to_s
    " "
  end
end

class RootNode < Treetop::Runtime::SyntaxNode
  def to_sql
    elements.collect do |item|
      item.to_sql
    end.join("\n")
  end
end

class IfStatement < Treetop::Runtime::SyntaxNode
  def to_sql
    output = "if " + condition.to_sql + " { " + t_result.to_sql + " }"
    output += " else { " + altern.e_result.to_sql + " }" unless altern.terminal?
    return output
  end
end

class FunctionNode < Treetop::Runtime::SyntaxNode
end
