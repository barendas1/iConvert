/*
Select *
From CmdProd_Sonag_RJ.dbo.icat As ICAT
Order By    LTrim(RTrim(Replace(ICAT.item_type, Char(160), ' '))),
            LTrim(RTrim(Replace(ICAT.item_cat, Char(160), ' '))),
            LTrim(RTrim(Replace(ICAT.descr, Char(160), ' ')))

Select *
From CmdProd_Sonag_RJ.dbo.icat As ICAT
Where ICAT.item_type <> '01'
Order By    LTrim(RTrim(Replace(ICAT.item_cat, Char(160), ' '))),
            LTrim(RTrim(Replace(ICAT.descr, Char(160), ' ')))
*/

Select	LTrim(RTrim(Replace(ILOC.loc_code, Char(160), ' '))) As [Plant Code],
    	LTrim(RTrim(Replace(IMST.item_code, Char(160), ' '))) As [Mix Code],
    	LTrim(RTrim(Replace(IMST.descr, Char(160), ' '))) As [Mix Description],
    	LTrim(RTrim(Replace(IMST.short_descr, Char(160), ' '))) As [Mix Short Description],
    	LTrim(RTrim(Replace(IMST.item_cat, Char(160), ' '))) As [Item Category],
    	Case when Isnull(IMST.strgth, -1.0) > 0.0 Then 28.0 Else Null End As [Strength Age],
    	Case when Isnull(IMST.strgth, -1.0) > 0.0 Then IMST.strgth Else Null End As [Strength],
    	IsNull(ILOC.air_pct, IMST.air_pct) As [Air Content],
    	Null As [Min Air Content],
    	Null As [Max Air Content],
    	Case 
    	    When Isnumeric(LTrim(RTrim(Replace(ILOC.slump, Char(160), ' ')))) = 1
    	    Then LTrim(RTrim(Replace(ILOC.slump, Char(160), ' ')))
    	    When Isnumeric(LTrim(RTrim(Replace(IMST.slump, Char(160), ' ')))) = 1
    	    Then LTrim(RTrim(Replace(IMST.slump, Char(160), ' ')))
    	    Else Null
    	End As [Slump],
    	LTrim(RTrim(Replace(IMST.min_slump, Char(160), ' '))) As [Min Slump],
    	LTrim(RTrim(Replace(IMST.max_slump, Char(160), ' '))) As [Max Slump],
    	'' As [Dispatch Slump Range],
    	'' As [Padding],
    	LTrim(RTrim(Replace(ICSt.const_item_code, Char(160), ' '))) As [Material Item Code],
    	LTrim(RTrim(Replace(MtrlIMST.descr, Char(160), ' '))) As [Material Description],
    	IsNull(ICST.qty, 0.0) As [Quantity],
    	LTrim(RTrim(Replace(Isnull(UOMS.descr, ICST.qty_uom), Char(160), ' '))) As [Unit Name],
    	IMST.update_date As [IMST Update Timestamp],
    	ILOC.update_date As [ILOC Update TimeStamp]
From CmdProd_SONAG_RJ.dbo.imst As IMST
Inner Join CmdProd_Sonag_RJ.dbo.icat As ICAT
On  LTrim(RTrim(Replace(IMST.item_cat, Char(160), ' '))) = LTrim(RTrim(Replace(ICAT.item_cat, Char(160), ' '))) And
    LTrim(RTrim(Replace(ICAT.item_type, Char(160), ' '))) = '01'
Inner Join CmdProd_SONAG_RJ.dbo.iloc As ILOC
On LTrim(RTrim(Replace(ILOC.item_code, Char(160), ' '))) = LTrim(RTrim(Replace(IMST.item_code, Char(160), ' ')))
Inner Join CmdProd_SONAG_RJ.dbo.icst As ICST
On	LTrim(RTrim(Replace(ICST.loc_code, Char(160), ' '))) = LTrim(RTrim(Replace(ILOC.loc_code, Char(160), ' '))) And
    LTrim(RTrim(Replace(ICST.item_code, Char(160), ' '))) = LTrim(RTrim(Replace(ILOC.item_code, Char(160), ' ')))
Left Join
(
	Select  -1 As ID,
	        LTrim(RTrim(Replace(ICST.loc_code, Char(160), ' '))) As Loc_Code,
	        LTrim(RTrim(Replace(ICST.item_code, Char(160), ' '))) As Item_Code
	From CmdProd_Sonag_RJ.dbo.icst As ICST
	Left Join CmdProd_Sonag_RJ.dbo.IMST As IMST
	On  LTrim(RTrim(Replace(ICST.const_item_code, Char(160), ' '))) = LTrim(RTrim(Replace(IMST.item_code, Char(160), ' ')))
	Where IMST.item_code Is Null
	Group By LTrim(RTrim(Replace(ICST.loc_code, Char(160), ' '))), LTrim(RTrim(Replace(ICST.item_code, Char(160), ' ')))
) As MissingMtrl
On  LTrim(RTrim(Replace(MissingMtrl.loc_code, Char(160), ' '))) = LTrim(RTrim(Replace(ICST.loc_code, Char(160), ' '))) And
    LTrim(RTrim(Replace(MissingMtrl.item_code, Char(160), ' '))) = LTrim(RTrim(Replace(ICST.item_code, Char(160), ' ')))
Inner Join CmdProd_SONAG_RJ.dbo.IMST As MtrlIMST
On LTrim(RTrim(Replace(ICST.const_item_code, Char(160), ' '))) = LTrim(RTrim(Replace(MtrlIMST.item_code, Char(160), ' ')))
Inner Join CmdProd_Sonag_RJ.dbo.icat As MtrlICAT
On LTrim(RTrim(Replace(MtrlIMST.item_cat, Char(160), ' '))) = LTrim(RTrim(Replace(MtrlICAT.item_cat, Char(160), ' ')))
Left Join CmdProd_SONAG_RJ.dbo.uoms As UOMS
On LTrim(RTrim(Replace(ICST.qty_uom, Char(160), ' '))) = LTrim(RTrim(Replace(UOMS.uom, Char(160), ' ')))
Where   MissingMtrl.ID Is Null And
        LTrim(RTrim(Replace(IsNull(ILOC.loc_code, ''), Char(160), ' ')))  In ('1', '2', '7') And
        (
    	    IMST.update_date >= Cast('2018-09-17' As Datetime) Or
    	    ILOC.update_date >= Cast('2018-09-17' As Datetime)
    	) And
    	(
    		LTrim(RTrim(Replace(IsNull(MtrlICAT.item_cat, ''), Char(160), ' '))) Not In ('AGG1', 'AGG2', 'CEMENT','CMT2', 'MICRO', 'SLAG') Or
    		LTrim(RTrim(Replace(IsNull(MtrlICAT.item_cat, ''), Char(160), ' '))) In ('AGG1', 'AGG2', 'CEMENT','CMT2', 'MICRO', 'SLAG') And
    		Isnull(ICST.qty, -1.0) > 0.0 
    	) 
Order By	LTrim(RTrim(Replace(ICST.loc_code, Char(160), ' '))),
    		LTrim(RTrim(Replace(ICST.item_code, Char(160), ' '))),
    		LTrim(RTrim(Replace(ICSt.const_item_code, Char(160), ' ')))

 
