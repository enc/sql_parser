class Statement < SqlParser::BaseStatement
  def to_sql
    command.to_sql.strip
  end
end

class SelectStatement < SqlParser::BaseStatement
  def to_sql
    elements.collect do |item|
      item.to_sql
    end.join("").strip
  end
end

class SpaceNode < SqlParser::BaseStatement
  def to_sql
    " "
  end
end

class OperationNode < SqlParser::BaseStatement
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

class RootNode < SqlParser::BaseStatement
  def to_sql
    elements.collect do |item|
      item.to_sql
    end.join("\n")
  end
end

class Topping < SqlParser::BaseStatement
  def to_sql
    " "
  end
end

class PlusOperator < SqlParser::BaseStatement
  def to_sql switch=false
    if switch
      "||"
    else
      "+"
    end
  end
end

class IfStatement < SqlParser::BaseStatement
  def to_sql
    output = "CASE WHEN " + condition.to_sql + " THEN " + t_result.to_sql
    output += " ELSE " + altern.e_result.to_sql unless altern.terminal?
    output += " END"
    return output
  end
end

class FunctionNode < SqlParser::BaseStatement
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
class CreateView < SqlParser::BaseStatement
end
class NumNode < SqlParser::BaseStatement

end

class StringNode < SqlParser::BaseStatement
  def to_sql
    string.to_sql
  end

  def is_string?
    true
  end
end

class FullNameNode < SqlParser::BaseStatement
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

class Gibberish < SqlParser::BaseStatement
  def to_sql
    ""
  end
end

class NameNode < SqlParser::BaseStatement
  def to_sql
    text_value.gsub(/[\[\]]/,'"')
  end
end
class Fieldlist < SqlParser::BaseStatement
end
class Field < SqlParser::BaseStatement
end
class Tablename < SqlParser::BaseStatement
end
class Identity < SqlParser::BaseStatement
  def to_sql
    add_preps "CREATE SEQUENCE #{context.gsub('"','')}_sq START 1;"
    return "DEFAULT nextval('#{context.gsub('"','')}_sq')"
  end
end
class TableConstraint < SqlParser::BaseStatement
  def to_sql
    add_inclosure "ALTER TABLE #{context} ADD PRIMARY KEY (#{idcolumn.to_sql});"
    return ""
  end
end
class CreateTable < SqlParser::BaseStatement
  def to_sql
    set_context tablename.to_sql
    [prependum,super,addendum].join "\n"
  end
end
