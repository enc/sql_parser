class Statement < Treetop::Runtime::SyntaxNode
  def to_sql
    command.to_sql.strip
  end
end

class SelectStatement < Treetop::Runtime::SyntaxNode
  def to_sql
    elements.collect do |item|
      item.to_sql
    end.join("").strip
  end
end

class SpaceNode < Treetop::Runtime::SyntaxNode
  def to_sql
    " "
  end
end

class OperationNode < Treetop::Runtime::SyntaxNode
  def to_sql
    left.to_sql.strip + ' ' + (is_string? ? op.to_sql(true) : op.to_sql) + ' ' + right.to_sql.strip
  end

  def is_string?
    if left.is_string? or right.is_string?
      return true
    else
      return false
    end
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

class PlusOperator < Treetop::Runtime::SyntaxNode
  def to_sql switch=false
    if switch
      "||"
    else
      "+"
    end
  end
end

class IfStatement < Treetop::Runtime::SyntaxNode
  def to_sql
    output = "CASE WHEN " + condition.to_sql + " THEN " + t_result.to_sql
    output += " ELSE " + altern.e_result.to_sql unless altern.terminal?
    output += " END"
    return output
  end
end

class FunctionNode < Treetop::Runtime::SyntaxNode
  def to_sql
    map(fname.to_sql) + rest.to_sql
  end

  def map name
    mapping = {
      "fnVAL" => "VAL"
    }

    if mapping.has_key? name
      mapping[name]
    else
      name
    end
  end
end
class CreateView < Treetop::Runtime::SyntaxNode
end
class NumNode < Treetop::Runtime::SyntaxNode

end

class StringNode < Treetop::Runtime::SyntaxNode
  def to_sql
    string.to_sql
  end

  def is_string?
    true
  end
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
