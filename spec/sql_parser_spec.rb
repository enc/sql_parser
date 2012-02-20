# encoding: utf-8
require 'spec_helper'

describe SqlParser do
  before(:all) do
    @parser = SqlParser::Parser.new("MssqlParser")
  end
  describe ".parse" do
    it "should parse simple select statement" do
      statement = @parser.parse "select chim;"
      statement.should_not be_nil
    end
    it "should parse sample select statements" do

      statement = @parser.parse "select 1, 4;"
      statement.should_not be_nil

      statement = @parser.parse "select 1 ll bb, 4;"
      statement.should be_nil

      statement = @parser.parse "select 'rrr';"
      statement.should_not be_nil

      statement = @parser.parse "select (joloopi ), bim;"
      statement.should_not be_nil
    end
    it "should parse operations" do

      statement = @parser.parse "select 3+4;"
      statement.should_not be_nil

      statement = @parser.parse "select 3 + 4;"
      statement.should_not be_nil

      statement = @parser.parse "select 3+sdffsd;"
      statement.should_not be_nil

      statement = @parser.parse "select 3+(sdffsd-5);"
      statement.should_not be_nil
    end
    it "should parse tables joins" do
      statement = @parser.parse "select bilbo from bimo;"
      statement.should_not be_nil

      statement = @parser.parse "select bilbo from bimo join bima on jim = bin;"
      statement.should_not be_nil

      statement = @parser.parse "select bilbo from bimo join bima on bimo.jim = bima.bin;"
      statement.should_not be_nil
    end

    it "should parse wheres " do
      statement = @parser.parse "select bilbo from bimo where count = 3;"
      statement.should_not be_nil

      statement = @parser.parse "SELECT prj_id, parent_prj_id FROM dbo.xb_projekte WHERE prj_id <> 135;"
      statement.should_not be_nil

      statement = @parser.parse "SELECT prj_id, parent_prj_id FROM dbo.xb_projekte WHERE prj_id or 135;"
      statement.should_not be_nil

      statement = @parser.parse "SELECT prj_id, parent_prj_id FROM dbo.xb_projekte WHERE prj_id or 135 > 12;"
      statement.should_not be_nil

      statement = @parser.parse "SELECT prj_id, parent_prj_id FROM dbo.xb_projekte WHERE (prj_id or 135) > (12);"
      statement.should_not be_nil

      # statement = @parser.parse "SELECT prj_id, parent_prj_id FROM dbo.xb_projekte WHERE prj_id or 135;"
      # statement.should_not be_nil

      statement = @parser.parse "SELECT prj_id, parent_prj_id FROM dbo.xb_projekte WHERE  (prj_id <> 135) AND (parent_prj_id = 127 OR parent_prj_id = 162 OR parent_prj_id = 170 OR parent_prj_id = 175 OR parent_prj_id = 191);"
      statement.should_not be_nil
    end

    it "should parse having and groupby" do
      statement = @parser.parse "SELECT dbo.abos.id, COUNT(dbo.abos_ausgelieferte_titeln.menge) AS Anzahlvonmenge, dbo.abos.ausgaben FROM dbo.abos INNER JOIN dbo.abos_ausgelieferte_titeln ON dbo.abos.bks_id = dbo.abos_ausgelieferte_titeln.bks_id AND dbo.abos.id = dbo.abos_ausgelieferte_titeln.abos_id WHERE (dbo.abos.status_id = 147) OR (dbo.abos.status_id = 148) GROUP BY dbo.abos.id, dbo.abos.ausgaben HAVING (COUNT(dbo.abos_ausgelieferte_titeln.menge) >= dbo.abos.ausgaben);"
      statement.should_not be_nil
    end
  end
end
