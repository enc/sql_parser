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
    output = "IF " + condition.to_sql + " THEN " + t_result.to_sql
    output += " ELSE " + altern.e_result.to_sql unless altern.terminal?
    output += " END IF"
    return output
  end
end

class FunctionNode < Treetop::Runtime::SyntaxNode
  def to_sql
    map(fname.to_sql) + rest.to_sql
  end

  def map name
    mapping = {
      fnVAL: 'VAL'
    }

    if mapping.has_key? name.to_sym
      mapping[name.to_sym]
      # "VAL"
    else
      name
    end
  end
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
