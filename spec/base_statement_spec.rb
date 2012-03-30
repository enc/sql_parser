# encoding: utf-8
require 'spec_helper'

describe SqlParser::BaseStatement do
  Given(:statement) { SqlParser::BaseStatement.new("jim",1) }
  Given(:final_statement) { SqlParser::BaseStatement.new("jim",1) }

  context "add appendix" do
    When { statement.add_inclosure "teststring" }
    Then {
      final_statement.addendum.should match("teststring")
      final_statement.addendum.should == ""
    }
  end

end
