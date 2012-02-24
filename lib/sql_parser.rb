require "sql_parser/version"
require 'treetop'
require "sql_parser/pgsql"
# require "sql_parser/node_extension"

Treetop.load(File.expand_path(File.join(File.dirname(__FILE__), "sql_parser/grammar/mssql.treetop")))

module SqlParser


  class Parser
    def initialize(name)
      @parser = Kernel.const_get(name).new
    end

    def parse(string)
      @last_result = @parser.parse(string)
    end

    def report
      if @last_result
        @last_result
      else
        puts @parser.failure_reason
        puts @parser.failure_line
        puts @parser.failure_column
      end
    end
  end
end
