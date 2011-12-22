require "sql_parser/version"
require 'treetop'
# require "sql_parser/node_extension"


module SqlParser

  Treetop.load(File.expand_path(File.join(File.dirname(__FILE__), "sql_parser/grammar/mssql.treetop")))
  @@parser = MssqlParser.new

  def self.parse(string)
    @@parser.parse(string)
  end
end
