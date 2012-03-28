require "sql_parser/version"
require 'treetop'
require 'beanstalk-client'
require "mongo_mapper"
# require "sql_parser/node_extension"

Treetop.load(File.expand_path(File.join(File.dirname(__FILE__), "sql_parser/grammar/mssql.treetop")))
MongoMapper.database = 'sqlwizz'

module SqlParser

  class Treetop::Runtime::SyntaxNode
    def to_sql switch=false
      if terminal?
        text_value
      else
        elements.collect do |item|
          item.to_sql
        end.join("")
      end
    end

    def is_string?
      false
    end
  end

  class BaseStatement < Treetop::Runtime::SyntaxNode
    def statement
      nil
    end

    def start_table name
      self.class.tname = name
    end

    def add_field name, typ
      if self.class.tname
        self.class.fields ||= []
        self.class.fields << [name, typ]
      end
    end

    def to_sql
      if self.class.tname
        self.class.fields.join
      else
        super
      end
    end

  end



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

  class Runner

    def initialize
      @parser = Parser.new('MssqlParser')
    end

    def run
      error_message = "It shouldn't be."
      beanstalk = Beanstalk::Pool.new(['localhost:11300'])
      beanstalk.watch "deliver"
      loop do
        job = beanstalk.reserve
        puts "The request(#{job.id}) " + job.body
        object = Request.find job.body
        result = @parser.parse object.source
        beanstalk.on_tube "return" do |beans|
          if result
            object.response = result.to_sql
            object.save
            puts "The result(#{job.id}) " + result.to_sql
          else
            object.response = @parser.report
            object.save
          end
          beans.put job.body
        end
        job.delete
      end
    end
  end

  # represents a single SQL conversion request
  class Request
    include MongoMapper::Document

    key :source, String
    key :response, String
  end
end
require "sql_parser/pgsql"
