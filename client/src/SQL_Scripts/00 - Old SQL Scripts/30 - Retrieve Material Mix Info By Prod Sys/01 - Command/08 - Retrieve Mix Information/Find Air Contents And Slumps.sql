Select IMST.item_code, IMST.descr, IMST.air_pct, IMST.pct_air, ILOC.air_pct
From CmdTest_RJ.dbo.imst As IMST
Inner Join CmdTest_RJ.dbo.ILOC As ILOC
On IMST.item_code = ILOC.item_code
Inner Join CmdTest_RJ.dbo.icat As ICat
On IMST.item_cat = ICAT.item_cat
Where   ICAT.item_type = '01' And
        (
        	Isnull(IMST.air_pct, -1.0) >= 0.0 Or
        	Isnull(IMST.pct_air, -1.0) >= 0.0 Or
        	Isnull(ILOC.air_pct, -1.0) >= 0.0
        )
Order By IMST.item_code

Select IMST.item_code, IMST.descr, ILOC.slump, ILOC.min_slump, ILOC.max_slump, IMST.slump, IMST.min_slump, IMST.max_slump
From CmdTest_RJ.dbo.imst As IMST
Inner Join CmdTest_RJ.dbo.ILOC As ILOC
On IMST.item_code = ILOC.item_code
Inner Join CmdTest_RJ.dbo.icat As ICat
On IMST.item_cat = ICAT.item_cat
Where   ICAT.item_type = '01' And
        (
        	Isnull(IMST.slump, '') <> '' Or
        	Isnull(IMST.min_slump, '') <> '' Or
        	Isnull(IMST.max_slump, '') <> '' Or
        	Isnull(ILOC.slump, '') <> '' Or
        	Isnull(ILOC.min_slump, '') <> '' Or
        	Isnull(ILOC.max_slump, '') <> '' 
        )
Order By IMST.item_code

Select IMST.item_code, IMST.descr, ILOC.slump, ILOC.min_slump, ILOC.max_slump, IMST.slump, IMST.min_slump, IMST.max_slump
From CmdTest_RJ.dbo.imst As IMST
Inner Join CmdTest_RJ.dbo.ILOC As ILOC
On IMST.item_code = ILOC.item_code
Inner Join CmdTest_RJ.dbo.icat As ICat
On IMST.item_cat = ICAT.item_cat
Where   ICAT.item_type = '01' And
        (
        	Isnull(IMST.slump, '') <> '' Or
        	Isnull(IMST.min_slump, '') <> '' Or
        	Isnull(IMST.max_slump, '') <> '' 
        )
Order By IMST.item_code

Select IMST.item_code, IMST.descr, ILOC.slump, ILOC.min_slump, ILOC.max_slump, IMST.slump, IMST.min_slump, IMST.max_slump
From CmdTest_RJ.dbo.imst As IMST
Inner Join CmdTest_RJ.dbo.ILOC As ILOC
On IMST.item_code = ILOC.item_code
Inner Join CmdTest_RJ.dbo.icat As ICat
On IMST.item_cat = ICAT.item_cat
Where   ICAT.item_type = '01' And
        (
        	Isnull(ILOC.slump, '') <> '' Or
        	Isnull(ILOC.min_slump, '') <> '' Or
        	Isnull(ILOC.max_slump, '') <> '' 
        )
Order By IMST.item_code

Select IMST.item_code, IMST.descr, ILOC.slump, ILOC.min_slump, ILOC.max_slump, IMST.slump, IMST.min_slump, IMST.max_slump
From CmdTest_RJ.dbo.imst As IMST
Inner Join CmdTest_RJ.dbo.ILOC As ILOC
On IMST.item_code = ILOC.item_code
Inner Join CmdTest_RJ.dbo.icat As ICat
On IMST.item_cat = ICAT.item_cat
Where   ICAT.item_type = '01' And
        (
        	Isnull(IMST.slump, -1.0) >= 0.0 Or
        	Isnull(IMST.min_slump, -1.0) >= 0.0 Or
        	Isnull(IMST.max_slump, -1.0) >= 0.0 Or
        	Isnull(ILOC.slump, -1.0) >= 0.0 Or
        	Isnull(ILOC.min_slump, -1.0) >= 0.0 Or
        	Isnull(ILOC.max_slump, -1.0) >= 0.0 
        )
Order By IMST.item_code
