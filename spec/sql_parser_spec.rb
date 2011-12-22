# encoding: utf-8
require 'spec_helper'

describe SqlParser do
  describe ".parse" do
    it "should parse simple select statement" do
      statement = subject.parse "select chim;"
      statement.should_not be_nil
    end
    it "should parse sample select statements" do

      statement = subject.parse "select 1, 4;"
      statement.should_not be_nil

      statement = subject.parse "select 1 ll bb, 4;"
      statement.should be_nil

      statement = subject.parse "select 'rrr';"
      statement.should_not be_nil

      statement = subject.parse "select (joloopi ), bim;"
      statement.should_not be_nil
    end
    it "should parse operations" do

      statement = subject.parse "select 3+4;"
      statement.should_not be_nil

      statement = subject.parse "select 3 + 4;"
      statement.should_not be_nil

      statement = subject.parse "select 3+sdffsd;"
      statement.should_not be_nil

      statement = subject.parse "select 3+(sdffsd-5);"
      statement.should_not be_nil
    end
    it "should parse joins" do
      statement = subject.parse "select bilbo from bimo join bima on jim=bin;"
      statement.should_not be_nil
    end
  end
end
