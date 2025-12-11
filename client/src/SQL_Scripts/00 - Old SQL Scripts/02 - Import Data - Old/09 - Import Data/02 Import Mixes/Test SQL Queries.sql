Select Distinct MixInfo.QuantityUnitName
From Data_Import_RJ.dbo.TestImport0000_XML_MixInfo As MixInfo

Select MixInfo.*
From Data_Import_RJ.dbo.TestImport0000_XML_MixInfo As MixInfo
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
From Data_Import_RJ.dbo.TestImport0000_XML_MixInfo As MixInfo
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
From Data_Import_RJ.dbo.TestImport0000_XML_MixInfo As MixInfo
Group By MixInfo.QuantityUnitName

Select *
From Data_Import_RJ.dbo.TestImport0000_XML_MixInfo

Select MixInfo.MaterialItemCode
From Data_Import_RJ.dbo.TestImport0000_XML_MixInfo As MixInfo
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
			From Data_Import_RJ.dbo.TestImport0000_XML_MixInfo As MixInfo
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
			From Data_Import_RJ.dbo.TestImport0000_XML_MixInfo As MixInfo
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
			From Data_Import_RJ.dbo.TestImport0000_XML_MixInfo As MixInfo
			Group By MixInfo.MaterialItemCode
		)
Group By ItemName.Name
Order By ItemName.Name

Select MixInfo.PlantCode, MixInfo.MixCode, MixInfo.MaterialItemCode
From Data_Import_RJ.dbo.TestImport0000_XML_MixInfo As MixInfo
Group By MixInfo.PlantCode, MixInfo.MixCode, MixInfo.MaterialItemCode
Having Count(*) > 0


Select MixInfo.PlantCode As [Plant Code], MixInfo.MixCode As [Mix Code], MixInfo.MixDescription As [Mix Description], 'The Mix Item Code is used for Materials in Quadrel.' As [Status Message]
From Data_Import_RJ.dbo.TestImport0000_XML_MixInfo As MixInfo
Inner Join dbo.Name As MixItemCode
On MixInfo.MixCode = MixItemCode.Name
Where MixItemCode.NameType Not In ('Mix', 'MixItem')
Group By MixInfo.PlantCode, MixInfo.MixCode, MixInfo.MixDescription
Order By MixInfo.PlantCode, MixInfo.MixCode

Select MixInfo.*
From Data_Import_RJ.dbo.TestImport0000_XML_MixInfo As MixInfo
Inner Join dbo.Plants As Plants
On MixInfo.PlantCode = Plants.Name
Inner Join dbo.Name As MixName
On MixInfo.MixCode = MixName.Name
Inner Join dbo.BATCH As Mix
On Mix.Plant_Link = Plants.PlantId And Mix.NameID = MixName.NameID
Left Join
(
    Select	Plants.Name As PlantCode,
		    MixNameInfo.Name As MixCode,
		    MixRecipe.MaterialItemCode 
    From dbo.Plants As Plants
    Inner Join dbo.Batch As Mix
    On Mix.Plant_Link = Plants.PlantId
    Inner Join dbo.Name As MixNameInfo
    On MixNameInfo.NameID = Mix.NameID
    Inner Join dbo.MaterialRecipe As MaterialRecipe
    On MaterialRecipe.EntityID = Mix.BATCHIDENTIFIER
    Inner Join dbo.MATERIAL As Material
    On Material.MATERIALIDENTIFIER = MaterialRecipe.MaterialID
    Inner Join dbo.ItemMaster As MtrlProdItem
    On MtrlProdItem.ItemMasterID = Material.ItemMasterID
    Inner Join dbo.Name As MtrlItemCode
    On MtrlItemCode.NameID = MtrlProdItem.NameID
    Inner Join Data_Import_RJ.dbo.TestImport0000_XML_MixInfo AS MixRecipe
    On	Plants.Name = MixRecipe.PlantCode And
	    MixNameInfo.Name = MixRecipe.MixCode And
	    MtrlItemCode.Name = MixRecipe.MaterialItemCode
    Where	Round(IsNull(MixRecipe.Quantity, -1.0), 6) =
		    Case
			    When Isnull(MaterialRecipe.QUANTITY, -1.0) < 0.0
			    Then -1.0
			    When MixRecipe.QuantityUnitName In ('GA', 'GL', 'GAL', 'GALLONS')
			    Then Round(MaterialRecipe.QUANTITY * 0.26417205 / (Material.SPECGR * 1.0), 6)
			    When MixRecipe.QuantityUnitName In ('LB', 'Pounds')
			    Then Round(MaterialRecipe.QUANTITY * 2.204622476, 6)
			    When MixRecipe.QuantityUnitName In ('OZ', 'LQ OZ', 'Ounces')
			    Then Round(MaterialRecipe.QUANTITY / (Material.SPECGR * 0.0651984837440621 * 0.45359240000781), 6)
			    When MixRecipe.QuantityUnitName = 'KG'
			    Then Round(MaterialRecipe.QUANTITY, 6)
			    When MixRecipe.QuantityUnitName = 'GR'
			    Then Round(MaterialRecipe.QUANTITY, 6) * 1000.0
			    When MixRecipe.QuantityUnitName In ('L', 'LT')
			    Then Round(MaterialRecipe.QUANTITY / Material.SPECGR / 1.0, 6)
			    When MixRecipe.QuantityUnitName In ('ML', 'CC')
			    Then Round(MaterialRecipe.QUANTITY / Material.SPECGR / 1.0 * 1000.0, 6)
			    When MixRecipe.QuantityUnitName In ('Each', 'Bag')
			    Then Round(MaterialRecipe.QUANTITY, 6)
			    When MixRecipe.QuantityUnitName In ('Cubic Yards')
			    Then Round(MaterialRecipe.QUANTITY / (201.974026 * Material.SPECGR * 1.0) * 0.26417205, 6)
			    Else -1.0
		    End
) As DBMix
On  DBMix.PlantCode = MixInfo.PlantCode And DBMix.MixCode = MixInfo.MixCode And DBMix.MaterialItemCode = MixInfo.MaterialItemCode
Where DBMix.PlantCode Is Null
Order By MixInfo.PlantCode, MixInfo.MixCode, MixInfo.MaterialItemCode

Select *
From Data_Import_RJ.dbo.TestImport0000_XML_Mix As MixInfo
Where MixInfo.PlantCode = '13' And MixInfo.ItemCode = '6079'

Select *
From Data_Import_RJ.dbo.TestImport0000_XML_MixInfo As MixInfo
