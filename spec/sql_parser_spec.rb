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
    it "should parse case statements" do
      statement = @parser.parse "SELECT dbo.abos.id, SUM((CASE WHEN abotiteln.status_id = 149 THEN 1 ELSE 0 END)) AS ausgelieferte, dbo.abos.ausgaben FROM dbo.abotiteln INNER JOIN dbo.abos ON dbo.abotiteln.abos_id = dbo.abos.id GROUP BY dbo.abos.id, dbo.abos.ausgaben;"
      statement.should_not be_nil
    end
    it "should parse is null" do
      statement = @parser.parse "SELECT     dbo.abos.id, dbo.abos.adr_id, dbo.abos.bks_id, dbo.abos.bst_id, dbo.abos.status_id FROM         dbo.abos INNER JOIN dbo.abotiteln ON dbo.abos.id = dbo.abotiteln.abos_id WHERE     (dbo.abotiteln.status_id IS NULL OR dbo.abotiteln.status_id = 150 OR dbo.abotiteln.status_id = 156 OR dbo.abotiteln.status_id = 173) AND (dbo.abos.status_id = 152) GROUP BY dbo.abos.id, dbo.abos.adr_id, dbo.abos.bks_id, dbo.abos.bst_id, dbo.abos.status_id;"
      statement.should_not be_nil
    end

    it "should parse a file" do
      text = <<EOF
USE [production]
GO

/****** Object:  View [dbo].[abos_duplikate]    Script Date: 02/21/2012 15:09:58 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[abos_duplikate]
AS 
   
   /*
   *   Generated by SQL Server Migration Assistant for Access.
   *   Contact accssma@microsoft.com or visit http://www.microsoft.com/sql/migration for more information.
   */
   SELECT 
      abos.adr_id, 
      Max(abos.bst_id) AS Maxvonbst_id, 
      abos.bks_id, 
      abotiteln.ausgabe, 
      Count(abotiteln.ausgabe) AS Anzahlvonausgabe
   FROM 
      abos 
         INNER JOIN abotiteln 
         ON abos.id = abotiteln.abos_id
   WHERE (((abos.status_id) = 147 OR (abos.status_id) = 148 OR (abos.status_id) = 177))
   GROUP BY abos.adr_id, abos.bks_id, abotiteln.ausgabe
   HAVING (((Count(abotiteln.ausgabe)) > 1))

GO


EOF
      statement = @parser.parse text
      statement.should_not be_nil

      text = <<EOF
USE [production]
GO

/****** Object:  View [dbo].[abos_eingefrorene]    Script Date: 02/23/2012 10:23:19 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[abos_eingefrorene]
AS 
   
   /*
   *   Generated by SQL Server Migration Assistant for Access.
   *   Contact accssma@microsoft.com or visit http://www.microsoft.com/sql/migration for more information.
   */
   SELECT 
      abos.id, 
      abos.adr_id, 
      abos.bks_id, 
      abos.bst_id, 
      abos.status_id
   FROM 
      abos 
         INNER JOIN abotiteln 
         ON abos.id = abotiteln.abos_id
   WHERE (((abotiteln.status_id) IS NULL OR ((abotiteln.status_id) = 150 OR (abotiteln.status_id) = 156 OR (abotiteln.status_id) = 173)) AND ((abos.status_id) = 152))
   GROUP BY 
      abos.id, 
      abos.adr_id, 
      abos.bks_id, 
      abos.bst_id, 
      abos.status_id

GO

EOF
      statement = @parser.parse text
      statement.should_not be_nil

      text = <<EOF
USE [production]
GO

/****** Object:  View [dbo].[abos_mit_ratenzahlung]    Script Date: 02/23/2012 10:43:00 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[abos_mit_ratenzahlung]
AS
SELECT     dbo.abos.status_id, ROUND(dbo.abos_payed_amounts.anteil_eingezahlt * dbo.abos.ausgaben - 0.25, 0) AS abbezahlte, 
                      dbo.abos_ausgelieferte_mengen.ausgelieferte, dbo.abos.ausgaben, dbo.abos.id, dbo.bls.payment_type, dbo.abos_payed_amounts.abo_anteil, 
                      dbo.abos_payed_amounts.anteil_eingezahlt, dbo.abos_payed_amounts.eingezahlt_geld, dbo.bls.Betrag
FROM         dbo.abos INNER JOIN
                      dbo.abos_ausgelieferte_mengen ON dbo.abos.id = dbo.abos_ausgelieferte_mengen.id INNER JOIN
                      dbo.bst ON dbo.abos.bst_id = dbo.bst.B_ID INNER JOIN
                      dbo.bls ON dbo.bst.b_det_ID = dbo.bls.Beleg INNER JOIN
                      dbo.abos_payed_amounts ON dbo.abos.id = dbo.abos_payed_amounts.id
WHERE     (dbo.bls.raten > 1)
GROUP BY dbo.abos.status_id, ROUND(dbo.abos_payed_amounts.anteil_eingezahlt * dbo.abos.ausgaben - 0.25, 0), 
                      dbo.abos_ausgelieferte_mengen.ausgelieferte, dbo.abos.ausgaben, dbo.abos.id, dbo.bls.payment_type, dbo.abos_payed_amounts.abo_anteil, 
                      dbo.abos_payed_amounts.anteil_eingezahlt, dbo.abos_payed_amounts.eingezahlt_geld, dbo.bls.Betrag
HAVING      (dbo.abos.status_id = 147) OR
                      (dbo.abos.status_id = 148) OR
                      (dbo.abos.status_id = 152)

GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "abos"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 114
               Right = 219
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "abos_ausgelieferte_mengen"
            Begin Extent = 
               Top = 6
               Left = 257
               Bottom = 99
               Right = 426
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "bst"
            Begin Extent = 
               Top = 6
               Left = 464
               Bottom = 114
               Right = 645
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "bls"
            Begin Extent = 
               Top = 6
               Left = 683
               Bottom = 114
               Right = 889
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "abos_payed_amounts"
            Begin Extent = 
               Top = 6
               Left = 927
               Bottom = 114
               Right = 1104
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 12
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
    ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'abos_mit_ratenzahlung'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'     Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'abos_mit_ratenzahlung'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'abos_mit_ratenzahlung'
GO


EOF
      statement = @parser.parse text
      puts @parser.report unless statement
      statement.should_not be_nil
    end

    it "should parse all views", :off => true do
      file = File.new("spec/sql_parser/view.txt")
      # file = File.new("spec/sql_parser/view_full.txt")
      statement = @parser.parse file.read
      puts @parser.report unless statement
      statement.should_not be_nil
    end

  end
  describe "mssql to psql" do

    it "should correct names" do
      ms = <<EOF
SELECT     prj_id, parent_prj_id
FROM         [dbo].[xb_projekte]
WHERE     (prj_id <> 135) AND (parent_prj_id = 127 OR
                      parent_prj_id = 162 OR
                      parent_prj_id = 170 OR
                      parent_prj_id = 175 OR
                      parent_prj_id = 191)
EOF
      target = "SELECT prj_id, parent_prj_id FROM \"xb_projekte\" WHERE (prj_id <> 135) AND (parent_prj_id = 127 OR parent_prj_id = 162 OR parent_prj_id = 170 OR parent_prj_id = 175 OR parent_prj_id = 191)\n "
      @parser.parse(ms).to_sql.should eq(target)

    end

  end

  it "should remove top from select" do
    ms = <<EOF
SELECT     TOP (2147483647) dbo.abos.id, dbo.subscriptions_open_end.abo_id AS open_end
FROM         dbo.abos LEFT OUTER JOIN
                      dbo.abos_trees ON dbo.abos.id = dbo.abos_trees.child_id LEFT OUTER JOIN
                      dbo.subscriptions_open_end ON dbo.abos.id = dbo.subscriptions_open_end.abo_id
WHERE     (dbo.abos_trees.child_id IS NULL)
ORDER BY dbo.abos.adr_id, dbo.abos.bks_id, dbo.abos.erstellt_am
EOF

      target = "SELECT abos.id, subscriptions_open_end.abo_id AS open_end FROM abos LEFT OUTER JOIN abos_trees ON abos.id = abos_trees.child_id LEFT OUTER JOIN subscriptions_open_end ON abos.id = subscriptions_open_end.abo_id WHERE (abos_trees.child_id IS NULL) ORDER BY abos.adr_id, abos.bks_id, abos.erstellt_am\n "
      @parser.parse(ms).to_sql.should eq(target)
  end
end
