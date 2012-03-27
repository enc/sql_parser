# encoding: utf-8
require 'spec_helper'

describe BaseStatement do
  describe "clean object" do
    its(:table) { must_be_nil }
  end
end
