require "sql_parser/version"
require 'treetop'
require 'beanstalk-client'
require "mongo_mapper"
# require "sql_parser/node_extension"

Treetop.load(File.expand_path(File.join(File.dirname(__FILE__), "sql_parser/grammar/mssql.treetop")))
MongoMapper.database = 'sqlwizz'

module SqlParser

  class Treetop::Runtime::SyntaxNode
    def to_sql joiner=""
      icon = joiner
      if terminal?
        text_value
      else
        elements.collect do |item|
          icon = item.connector if item.respond_to? :connector
          item.to_sql joiner
        end.join(icon)
      end
    end

    def is_string?
      false
    end
  end

  class BaseStatement < Treetop::Runtime::SyntaxNode

    def to_sql joiner=""
      if terminal?
        text_value
      else
        elements.collect do |item|
          item.to_sql joiner
        end.join(joiner)
      end
    end

    def self.typeal return_element
      define_method :to_sql do
        return return_element
      end
    end


    def self.seperator character

      define_method :connector do
        return character
      end

    end

    def add_preps text
      @@preps ||= []
      @@preps << text
    end

    def add_inclosure text
      @@inclosures ||= []
      @@inclosures << text
    end

    def prependum
      @@preps ||= []
      result = @@preps.join("\n")
      @@preps = []
      return result
    end

    def addendum
      @@inclosures ||= []
      result = @@inclosures.join("\n")
      @@inclosures = []
      @@context = nil
      return result
    end

    def set_context name
      @@context = name
    end

    def context
      @@context
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
