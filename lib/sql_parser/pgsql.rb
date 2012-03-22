class BaseStatement < Treetop::Runtime::SyntaxNode

end

class Statement < BaseStatement
  def to_sql
    command.to_sql.strip
  end
end

class SelectStatement < BaseStatement
  def to_sql
    elements.collect do |item|
      item.to_sql
    end.join("").strip
  end
end

class SpaceNode < BaseStatement
  def to_sql
    " "
  end
end

class OperationNode < BaseStatement
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

class RootNode < BaseStatement
  def to_sql
    elements.collect do |item|
      item.to_sql
    end.join("\n")
  end
end

class Topping < BaseStatement
  def to_sql
    " "
  end
end

class PlusOperator < BaseStatement
  def to_sql switch=false
    if switch
      "||"
    else
      "+"
    end
  end
end

class IfStatement < BaseStatement
  def to_sql
    output = "CASE WHEN " + condition.to_sql + " THEN " + t_result.to_sql
    output += " ELSE " + altern.e_result.to_sql unless altern.terminal?
    output += " END"
    return output
  end
end

class FunctionNode < BaseStatement
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
class CreateView < BaseStatement
end
class NumNode < BaseStatement

end

class StringNode < BaseStatement
  def to_sql
    string.to_sql
  end

  def is_string?
    true
  end
end

class FullNameNode < BaseStatement
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

class Gibberish < BaseStatement
  def to_sql
    ""
  end
end

class NameNode < BaseStatement
  def to_sql
    text_value.gsub(/[\[\]]/,'"')
  end
end
class Fieldlist < BaseStatement
end
class Field < BaseStatement
end
class Tablename < BaseStatement
end
class CreateTable < BaseStatement
end
