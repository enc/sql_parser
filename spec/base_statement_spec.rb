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
      subject.start_context("bls").should_not be_nil
    end

    subject { SqlParser::BaseStatement.new("jim", 1).tap do |s|
      s.start_context "bls"
    end
    }

    it "should accept field from other classes" do
      secundo.add_field "foo", "bar"
      subject.add_constraint "line"
      subject.to_sql.should match("line")
    end

    it "should remember contraints" do
    end

  end

end
