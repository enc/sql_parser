# encoding: utf-8
require 'spec_helper'

describe SqlParser::BaseStatement do
  context "before table statement" do
    subject { SqlParser::BaseStatement.new("jim", 1) }

    its(:statement) { should be_nil }

  end
  context "with fields and contraints" do
    subject { SqlParser::BaseStatement.new("jim", 1) }
    let(:secundo) { SqlParser::BaseStatement.new("jim", 2) }

    it "should initialize a table decalration" do
      subject.start_table("bls").should_not be_nil
    end

    subject { SqlParser::BaseStatement.new("jim", 1).tap do |s|
      s.start_table "bls"
    end
    }

    it "should accept field from other classes" do
      secundo.add_field "foo", "bar"
      subject.to_sql.should match("foo")

    end
  end
end
