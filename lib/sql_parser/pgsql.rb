# encoding: utf-8
class Statement < SqlParser::BaseStatement
  def to_sql joiner=""
    command.to_sql.strip
  end
end

class SelectStatement < SqlParser::BaseStatement
  def to_sql joiner=""
    elements.collect do |item|
      item.to_sql
    end.join("").strip
  end
end

class SpaceNode < SqlParser::BaseStatement
  def to_sql joiner=""
    " "
  end
end

class OperationNode < SqlParser::BaseStatement
  def to_sql joiner=""
    left.to_sql.strip + ' ' + (is_string? ? op.to_sql("f") : op.to_sql) + ' ' + right.to_sql.strip
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
  def to_sql joiner=""
    elements.collect do |item|
      item.to_sql
    end.join("\n")
  end
end

class Topping < SqlParser::BaseStatement
  def to_sql joiner=""
    " "
  end
end

class PlusOperator < SqlParser::BaseStatement
  def to_sql  joiner=""
    if joiner == "f"
      "||"
    else
      "+"
    end
  end
end

class IfStatement < SqlParser::BaseStatement
  def to_sql joiner=""
    output = "CASE WHEN " + condition.to_sql + " THEN " + t_result.to_sql
    output += " ELSE " + altern.e_result.to_sql unless altern.terminal?
    output += " END"
    return output
  end
end

class FunctionNode < SqlParser::BaseStatement
  def to_sql joiner=""
    map(fname.to_sql) + rest.to_sql
  end

  def map name
    mapping = {
      "fnVAL" => "VAL",
      "isnull" => "coalesce",
      "getdate" => "now"
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
  def to_sql joiner=""
    string.to_sql joiner=""
  end

  def is_string?
    true
  end
end

class FullNameNode < SqlParser::BaseStatement
  def to_sql joiner=""
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
  def to_sql joiner=""
    ""
  end
end

class PNameNode < SqlParser::BaseStatement
  def to_sql joiner=""
    text_value.gsub(/[\[\]]/,'"').downcase
  end
end
class NameNode < SqlParser::BaseStatement
  def to_sql joiner=""
    content = text_value.downcase
    if content.index('ä') or content.index('ö') or content.index('ü')
      '"' + content + '"'
    else
      content
    end
  end
end
class Fieldlist < SqlParser::BaseStatement
end
class Field < SqlParser::BaseStatement
end
class Tablename < SqlParser::BaseStatement
end
class Identity < SqlParser::BaseStatement
  def to_sql joiner=""
    add_preps "CREATE SEQUENCE #{context.gsub('"','')}_sq START 1;"
    return "DEFAULT nextval('#{context.gsub('"','')}_sq')"
  end
end
class TableConstraint < SqlParser::BaseStatement
  def to_sql joiner=""
    add_inclosure "ALTER TABLE #{context} ADD PRIMARY KEY (#{idcolumn.to_sql});"
    return ""
  end
end
class CreateTable < SqlParser::BaseStatement
  def to_sql joiner=""
    set_context tablename.to_sql
    [prependum,super,addendum].join "\n"
  end
end
class RowDefinition < SqlParser::BaseStatement
  seperator ","

  def to_sql joiner=""
    "#{name.to_sql} #{type_expression.to_sql} #{fieldoptions.to_sql}"
  end
end
class TypeExpression < SqlParser::BaseStatement
  def to_sql joiner=""
    if options.to_sql.match "IDENTITY" and type.to_sql == "int"
      "serial"
    elsif options.to_sql.match "max" and type.to_sql == "varchar"
      "text"
    elsif type.to_sql.match "timestamp"
      map_type(type.to_sql)
    else
      map_type(type.to_sql) + options.to_sql
    end
  end

  def map_type type
    mapping = {
      "int" => "integer",
      "nvarchar" => "varchar",
      "bit" => "boolean",
      "tinyint" => "smallint",
      "datetime" => "timestamp with time zone"
    }
    if mapping.key? type
      mapping[type]
    else
      type
    end
  end
end
class GoKack < SqlParser::BaseStatement
  def to_sql joiner=""
    ";"
  end
end
class CrapStatement < SqlParser::BaseStatement
  def to_sql joiner=""
    ""
  end
end
class IntegerType < SqlParser::BaseStatement
  typeal "int"
end
class VarcharType < SqlParser::BaseStatement
  typeal "varchar"
end
class DateTimeType < SqlParser::BaseStatement
  typeal "timestamp with time zone"
end
class BoolType < SqlParser::BaseStatement
  typeal "boolean"
end
class TimeStampType < SqlParser::BaseStatement
  typeal "timestamp"
end
class TypeStatement < SqlParser::BaseStatement
  typeal "pp"
end
class TypeStatement < SqlParser::BaseStatement
  typeal "pp"
end
class TypeStatement < SqlParser::BaseStatement
  typeal "pp"
end
