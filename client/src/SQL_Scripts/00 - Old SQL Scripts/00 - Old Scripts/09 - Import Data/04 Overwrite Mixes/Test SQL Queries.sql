Select Max(Batch.MixNameCode), Max(Batch.CODE)
From Sonag_RJ.dbo.BATCH As Batch

Select Top 10 *
From dbo.BATCH As Mix
Order By Mix.BATCHIDENTIFIER Desc

Select *
From Data_Import_RJ.dbo.TestImport0000_MixInfo As MixInfo 
Order By MixInfo.AutoID

Select *
From Data_Import_RJ.dbo.TestImport0000_MixInfo As MixInfo
Where   MixInfo.AutoID In
        (
            Select Min(MixInfo.AutoID)
            From Data_Import_RJ.dbo.TestImport0000_MixInfo As MixInfo
            Group By MixInfo.PlantCode, MixInfo.MixCode	
        ) 
Order By MixInfo.AutoID

Select MixInfo.*
From Data_Import_RJ.dbo.TestImport0000_MixInfo As MixInfo
Left Join
(
	Select -1 As ID, Plants.Name As PlantCode, MixName.Name As MixCode
	From dbo.Plants As Plants
	Inner Join dbo.BATCH As Mix
	On Mix.Plant_Link = Plants.PlantId
	Inner Join dbo.Name As MixName
	On MixName.NameID = Mix.NameID
	Group By Plants.Name, MixName.Name
) As ExistingMixInfo
On  ExistingMixInfo.PlantCode = MixInfo.PlantCode And
    ExistingMixInfo.MixCode = MixInfo.MixCode
Where ExistingMixInfo.ID Is Null

Select *
From Data_Import_RJ.dbo.TestImport0000_MixInfo As MixInfo
Left Join
(
	Select -1 As ID, Plants.Name As PlantCode, MixName.Name As MixCode, ItemName.Name As MaterialItemCode
	From dbo.Plants As Plants
	Inner Join dbo.BATCH As Mix
	On Mix.Plant_Link = Plants.PlantId
	Inner Join dbo.Name As MixName
	On MixName.NameID = Mix.NameID
	Inner Join dbo.MaterialRecipe As Recipe
	On Recipe.EntityID = Mix.BATCHIDENTIFIER
	Inner Join dbo.MATERIAL As Material
	On Material.MATERIALIDENTIFIER = Recipe.MaterialID
	Inner Join dbo.ItemMaster As ItemMaster
	On ItemMaster.ItemMasterID = Material.ItemMasterID
	Inner Join dbo.Name As ItemName
	On ItemName.NameID = ItemMaster.NameID
	Group By Plants.Name, MixName.Name, ItemName.Name
) As ExistingMixInfo
On  ExistingMixInfo.PlantCode = MixInfo.PlantCode And
    ExistingMixInfo.MixCode = MixInfo.MixCode And
    ExistingMixInfo.MaterialItemCode = MixInfo.MaterialItemCode
Where ExistingMixInfo.ID Is Null

Select MixInfo.QuantityUnitName
From Data_Import_RJ.dbo.TestImport0000_MixInfo As MixInfo
Group By MixInfo.QuantityUnitName

Select *
From Data_Import_RJ.dbo.TestImport0000_MixInfo

Select MixInfo.MaterialItemCode
From Data_Import_RJ.dbo.TestImport0000_MixInfo As MixInfo
Group By MixInfo.MaterialItemCode
Order By MixInfo.MaterialItemCode

Select Plants.Name, Count(*)
From CANEST_Quadrel_PROD_RJ.dbo.Plants As Plants
Inner Join CANEST_Quadrel_PROD_RJ.dbo.Material As Material
On Material.PlantID = Plants.PlantId
Inner Join CANEST_Quadrel_PROD_RJ.dbo.ItemMaster As ItemMaster
On ItemMaster.ItemMasterID = Material.ItemMasterID
Inner Join CANEST_Quadrel_PROD_RJ.dbo.Name As ItemName
On ItemName.NameID = ItemMaster.NameID
Where	ItemName.Name In
		(
			Select MixInfo.MaterialItemCode
			From Data_Import_RJ.dbo.TestImport0000_MixInfo As MixInfo
			Group By MixInfo.MaterialItemCode
		)
Group By Plants.Name
Having Count(Distinct ItemName.Name) >= 30

Select ItemName.Name
From CANEST_Quadrel_PROD_RJ.dbo.Plants As Plants
Inner Join CANEST_Quadrel_PROD_RJ.dbo.Material As Material
On Material.PlantID = Plants.PlantId
Inner Join CANEST_Quadrel_PROD_RJ.dbo.ItemMaster As ItemMaster
On ItemMaster.ItemMasterID = Material.ItemMasterID
Inner Join CANEST_Quadrel_PROD_RJ.dbo.Name As ItemName
On ItemName.NameID = ItemMaster.NameID
Where	ItemName.Name In
		(
			Select MixInfo.MaterialItemCode
			From Data_Import_RJ.dbo.TestImport0000_MixInfo As MixInfo
			Group By MixInfo.MaterialItemCode
		)
Group By ItemName.Name
Order By ItemName.Name

Select ItemName.Name
From CANEST_Quadrel_Test_RJ.dbo.Plants As Plants
Inner Join CANEST_Quadrel_Test_RJ.dbo.Material As Material
On Material.PlantID = Plants.PlantId
Inner Join CANEST_Quadrel_Test_RJ.dbo.ItemMaster As ItemMaster
On ItemMaster.ItemMasterID = Material.ItemMasterID
Inner Join CANEST_Quadrel_Test_RJ.dbo.Name As ItemName
On ItemName.NameID = ItemMaster.NameID
Where	ItemName.Name In
		(
			Select MixInfo.MaterialItemCode
			From Data_Import_RJ.dbo.TestImport0000_MixInfo As MixInfo
			Group By MixInfo.MaterialItemCode
		)
Group By ItemName.Name
Order By ItemName.Name

Select MixInfo.PlantCode, MixInfo.MixCode, MixInfo.MaterialItemCode
From Data_Import_RJ.dbo.TestImport0000_MixInfo As MixInfo
Group By MixInfo.PlantCode, MixInfo.MixCode, MixInfo.MaterialItemCode
Having Count(*) > 0

Select  ILOC.loc_code, ILOC.item_code, ILOC.curr_std_cost, IMST.descr,
        IMST.short_descr, IMST.item_cat, IMLB.batch_code
From CmdTest_RJ.dbo.iloc As ILOC
Inner Join CmdTest_RJ.dbo.imst As IMST
On IMST.item_code = ILOC.item_code
Inner Join CmdTest_RJ.dbo.icat As ICAT
On ICAT.item_cat = IMST.item_cat
Left Join CmdTest_RJ.dbo.imlb As IMLB
On ILOC.loc_code = IMLB.loc_code And ILOC.item_code = IMLB.item_code
Where ICAT.item_type <> '01'
Order By ILOC.loc_code, ILOC.item_code

Select  ILOC.loc_code, ILOC.item_code, IMST.descr, IMST.short_descr, IMST.item_cat, IMST.strgth, ILOC.air_pct, ICST.const_item_code,
ICST.qty, UOMS.short_descr
From CmdTest_RJ.dbo.IMST As IMST
Inner Join CmdTest_RJ.dbo.iloc As ILOC
On ILOC.item_code = IMST.item_code
Inner Join CmdTest_RJ.dbo.ICST As ICST
On  ICST.loc_code = ILOC.loc_code And
    ICST.item_code = ILOC.item_code
Inner Join CmdTest_RJ.dbo.imst As ConstIMST
On ICST.const_item_code = ConstIMST.item_code
Inner Join CmdTest_RJ.dbo.uoms As UOMS
On ICST.qty_uom = UOMS.uom
Order By ICST.loc_code, ICST.item_code, ICST.const_item_code

Select  ILOC.loc_code, ILOC.item_code, IMST.descr, IMST.short_descr, IMST.item_cat, IMST.strgth, ILOC.air_pct, ICST.const_item_code,
ICST.qty, UOMS.short_descr
From CmdTest_RJ.dbo.IMST As IMST
Inner Join CmdTest_RJ.dbo.iloc As ILOC
On ILOC.item_code = IMST.item_code
Inner Join CmdTest_RJ.dbo.ICST As ICST
On  ICST.loc_code = ILOC.loc_code And
    ICST.item_code = ILOC.item_code
Inner Join CmdTest_RJ.dbo.imst As ConstIMST
On ICST.const_item_code = ConstIMST.item_code
Inner Join CmdTest_RJ.dbo.uoms As UOMS
On ICST.qty_uom = UOMS.uom
Where ICST.qty = 0.0 And ICST.const_item_code Not Like '%Cement%'
Order By ICST.loc_code, ICST.item_code, ICST.const_item_code
