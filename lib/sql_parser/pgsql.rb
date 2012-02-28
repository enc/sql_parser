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
  def to_sql
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

class Topping < Treetop::Runtime::SyntaxNode
  def to_sql
    " "
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
class CreateView < Treetop::Runtime::SyntaxNode
end

class FullNameNode < Treetop::Runtime::SyntaxNode
  def to_sql
    output =
    elements.map do |item|
      if item.to_sql.include? "dbo"
        ""
      else
        item.to_sql
      end
    end.join("").gsub(/(^\.|\.$)/,"")
  end
end

class Gibberish < Treetop::Runtime::SyntaxNode
  def to_sql
    ""
  end
end

class NameNode < Treetop::Runtime::SyntaxNode
  def to_sql
    text_value.gsub(/[\[\]]/,'"')
  end
end
class Fieldlist < Treetop::Runtime::SyntaxNode
end
class Field < Treetop::Runtime::SyntaxNode
end
class Tablename < Treetop::Runtime::SyntaxNode
end
