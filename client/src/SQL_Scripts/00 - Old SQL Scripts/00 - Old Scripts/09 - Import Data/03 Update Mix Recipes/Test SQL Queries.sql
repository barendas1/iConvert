Select ICST.*
From CmdTest_RJ.dbo.icst As ICST
Left Join
(
	Select -1 As ID, Plants.Name As PlantCode, ItemName.Name As ItemCode
	From Sonag_RJ.dbo.Plants As Plants
	Inner Join Sonag_RJ.dbo.MATERIAL As Material
	On Material.PlantID = Plants.PlantId
	Inner Join Sonag_RJ.dbo.ItemMaster As ItemMaster
	On ItemMaster.ItemMasterID = Material.ItemMasterID
	Inner Join  Sonag_RJ.dbo.Name As ItemName
	On ItemName.NameID = ItemMaster.NameID
	Group By Plants.Name, ItemName.Name
) As MaterialInfo
On	dbo.TrimNVarChar(ICST.loc_code) = MaterialInfo.PlantCode And
	dbo.TrimNVarChar(ICST.const_item_code) = MaterialInfo.ItemCode
Where MaterialInfo.ID Is Null

Select MixInfo.QuantityUnitName
From Data_Import_RJ.dbo.TestImport0000_MixInfo As MixInfo
Group By MixInfo.QuantityUnitName

Select *
From Data_Import_RJ.dbo.TestImport0000_MixInfo As MixInfo
Where MixInfo.MixCode = '71829'
Order By MixInfo.PlantCode, MixInfo.MixCode, MixInfo.MaterialItemCode


Select *
From Data_Import_RJ.dbo.TestImport0000_MixInfo As MixInfo
Order By MixInfo.PlantCode, MixInfo.MixCode, MixInfo.MaterialItemCode
