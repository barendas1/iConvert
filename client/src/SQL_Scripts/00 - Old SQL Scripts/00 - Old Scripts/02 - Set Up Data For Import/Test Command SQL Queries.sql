Select *
From CmdTest_RJ.dbo.icat As ICat
Order By ICAT.item_type, ICAT.item_cat

Select *
From CmdTest_RJ.dbo.icat As ICat
Where ICat.item_type <> '01'
Order By ICAT.item_cat

Select IMST.item_cat
From CmdTest_RJ.dbo.icst As ICST
Inner Join CmdTest_RJ.dbo.imst As IMST
On dbo.TrimNVarChar(ICST.const_item_code) = dbo.TrimNVarChar(IMST.item_code)
Group By IMST.item_cat
Order By IMST.item_cat

Select UOMS.descr
From CmdTest_RJ.dbo.icst As ICST
Inner Join CmdTest_RJ.dbo.UOMS As UOMS
On dbo.TrimNVarChar(ICST.qty_uom) = dbo.TrimNVarChar(UOMS.uom)
Group By UOMS.descr
Order By UOMS.descr

Select ICST.*
From CmdTest_RJ.dbo.icst As ICST
Inner Join CmdTest_RJ.dbo.UOMS As UOMS
On dbo.TrimNVarChar(ICST.qty_uom) = dbo.TrimNVarChar(UOMS.uom)
Where dbo.TrimNVarChar(UOMS.descr) = 'Each'

Select *
From CmdTest_RJ.dbo.locn As LOCN

Select Top 1000 *
From CmdTest_RJ.dbo.tick

Select UOMS.descr
From CmdTest_RJ.dbo.twgt As TWGT
Inner Join CmdTest_RJ.dbo.UOMS As UOMS
On dbo.TrimNVarChar(TWGT.actl_batch_qty_uom) = dbo.TrimNVarChar(UOMS.uom)
Group By UOMS.descr
Order By UOMS.descr 

Select IMST.item_cat
From CmdTest_RJ.dbo.twgt As TWGT
Inner Join CmdTest_RJ.dbo.imst As IMST
On dbo.TrimNVarChar(TWGT.const_prod_code) = dbo.TrimNVarChar(IMST.item_code)
Group By IMST.item_cat
Order By IMST.item_cat 

Select Count(*)
From CmdTest_RJ.dbo.tick

Select dbo.TrimNVarChar(ILOC.loc_code), dbo.TrimNVarChar(ILOC.item_code)
From CmdTest_RJ.dbo.iloc As ILOC
Group By dbo.TrimNVarChar(ILOC.loc_code), dbo.TrimNVarChar(ILOC.item_code)
Having Count(*) > 1

Select MaterialInfo.PlantName, MaterialInfo.ItemCode
From Data_Import_RJ.dbo.TestImport0000_MaterialInfo As MaterialInfo
Group By MaterialInfo.PlantName, MaterialInfo.ItemCode
Having Count(*) > 1

Select MaterialInfo.Name
From Data_Import_RJ.dbo.TestImport0000_MainMaterialInfo As MaterialInfo
Group By MaterialInfo.Name
Having Count(*) > 1

Select dbo.TrimNVarChar(IMST.item_code)
From CmdTest_RJ.dbo.imst As IMST
Group By dbo.TrimNVarChar(IMST.item_code)
Having Count(*) > 1

Select dbo.TrimNVarChar(IMLB.loc_code), dbo.TrimNVarChar(IMLB.item_code)
From CmdTest_RJ.dbo.IMLB As IMLB
Group By dbo.TrimNVarChar(IMLB.loc_code), dbo.TrimNVarChar(IMLB.item_code)
Having Count(*) > 1

Select *
From CmdTest_RJ.dbo.imlb As IMLB
Inner Join
(
    Select dbo.TrimNVarChar(IMLB.loc_code) As loc_code, dbo.TrimNVarChar(IMLB.item_code) As item_code
    From CmdTest_RJ.dbo.IMLB As IMLB
    Group By dbo.TrimNVarChar(IMLB.loc_code), dbo.TrimNVarChar(IMLB.item_code)
    Having Count(*) > 1
) As DupIMLB
On  DupIMLB.loc_code = dbo.TrimNVarChar(IMLB.loc_code) And
    DupIMLB.item_code = dbo.TrimNVarChar(IMLB.item_code)

Select *
From CmdTest_RJ.dbo.IMLB
Select	dbo.TrimNVarChar(ILOC.loc_code), 
		dbo.TrimNVarChar(IMST.item_code)
From CmdTest_RJ.dbo.imst As IMST
Inner Join CmdTest_RJ.dbo.iloc As ILOC
On dbo.TrimNVarChar(ILOC.item_code) = dbo.TrimNVarChar(IMST.item_code)
Left Join CmdTest_RJ.dbo.imlb As IMLB
On	dbo.TrimNVarChar(IMLB.loc_code) = dbo.TrimNVarChar(ILOC.loc_code) And
	dbo.TrimNVarChar(IMLB.item_code) = dbo.TrimNVarChar(ILOC.item_code)
Inner Join Data_Import_RJ.dbo.TestImport0000_MaterialItemCategory As CategoryInfo
On dbo.TrimNVarChar(IMST.item_cat) = dbo.TrimNVarChar(CategoryInfo.Name)
Inner Join Data_Import_RJ.dbo.TestImport0000_MainMaterialInfo As MaterialInfo
On dbo.TrimNVarChar(IMST.item_code) = dbo.TrimNVarChar(MaterialInfo.Name)
Left Join Data_Import_RJ.dbo.TestImport0000_MaterialInfo As ExistingMaterialInfo
On	dbo.TrimNVarChar(ILOC.loc_code) = dbo.TrimNVarChar(ExistingMaterialInfo.PlantName) And
	dbo.TrimNVarChar(IMST.item_code) = dbo.TrimNVarChar(ExistingMaterialInfo.ItemCode)
Where ExistingMaterialInfo.AutoID Is Null
Group By	dbo.TrimNVarChar(ILOC.loc_code), 
			dbo.TrimNVarChar(IMST.item_code)
Having Count(*) > 1
Order By	dbo.TrimNVarChar(ILOC.loc_code), 
			dbo.TrimNVarChar(IMST.item_code)

Select dbo.TrimNVarChar( ILOC.loc_code)
From CmdTest_RJ.dbo.iloc As ILOC
Group By dbo.TrimNVarChar( ILOC.loc_code)

Select *
From CmdTest_RJ.dbo.locn

