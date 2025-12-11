Print Cast([dbo].[GetSelectSQLQueryFromTableName]('dbo', 'LOCN') As Ntext)
Print Char(13) + Char(10) + Char(13) + Char(10)
Print Cast([dbo].[GetSelectSQLQueryFromTableName]('dbo', 'IMST') As NText)
Print Char(13) + Char(10) + Char(13) + Char(10)
Print Cast([dbo].[GetSelectSQLQueryFromTableName]('dbo', 'ILOC') As Ntext)
Print Char(13) + Char(10) + Char(13) + Char(10)
Print Cast([dbo].[GetSelectSQLQueryFromTableName]('dbo', 'ICST') As Ntext)
Print Char(13) + Char(10) + Char(13) + Char(10)
Print Cast([dbo].[GetSelectSQLQueryFromTableName]('dbo', 'IMLB') As Ntext)
Print Char(13) + Char(10) + Char(13) + Char(10)
Print Cast([dbo].[GetSelectSQLQueryFromTableName]('dbo', 'ICAT') As Ntext)
Print Char(13) + Char(10) + Char(13) + Char(10)
Print Cast([dbo].[GetSelectSQLQueryFromTableName]('dbo', 'UOMS') As Ntext)


Select Ltrim(Rtrim(IMST.item_code))
From dbo.IMST IMST
Group By Ltrim(Rtrim(IMST.item_code))
Having Count (*) > 1

Select Ltrim(Rtrim(ILOC.item_code)), Ltrim(Rtrim(ILOC.loc_code))
From dbo.ILOC ILOC
Group By Ltrim(Rtrim(ILOC.item_code)), Ltrim(Rtrim(ILOC.loc_code))
Having Count (*) > 1

Select Ltrim(Rtrim(ICST.item_code)), Ltrim(Rtrim(ICST.loc_code)), Ltrim(Rtrim(ICST.const_item_code))
From dbo.icst ICST
Group By Ltrim(Rtrim(ICST.item_code)), Ltrim(Rtrim(ICST.loc_code)), Ltrim(Rtrim(ICST.const_item_code))
Having Count (*) > 1

Select Ltrim(Rtrim(IMLB.item_code)), Ltrim(Rtrim(IMLB.loc_code)), Ltrim(Rtrim(IMLB.batch_code))
From dbo.IMLB IMLB
Group By Ltrim(Rtrim(IMLB.item_code)), Ltrim(Rtrim(IMLB.loc_code)), Ltrim(Rtrim(IMLB.batch_code))
Having Count (*) > 1

Select Ltrim(Rtrim(IMLB.item_code)), Ltrim(Rtrim(IMLB.loc_code))
From dbo.IMLB IMLB
Group By Ltrim(Rtrim(IMLB.item_code)), Ltrim(Rtrim(IMLB.loc_code))
Having Count (*) > 1

Select IMLB.*
From dbo.IMLB IMLB
Inner Join
(
    Select Ltrim(Rtrim(IMLB.item_code)) As Item_Code, Ltrim(Rtrim(IMLB.loc_code)) As Loc_Code
    From dbo.IMLB IMLB
    Group By Ltrim(Rtrim(IMLB.item_code)), Ltrim(Rtrim(IMLB.loc_code))
    Having Count (*) > 1
) As MultIMLB
On  MultIMLB.loc_code = Ltrim(Rtrim(IMLB.loc_code)) And
    MultIMLB.item_code = Ltrim(Rtrim(IMLB.item_code))
Order By IMLB.loc_code, IMLB.item_code, IMLB.batch_code
