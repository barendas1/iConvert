/*
Select Avg(Material.SPECGR)
From ARGOS_USA_RJ.dbo.MATERIAL As Material
Inner Join iServiceDataExchange.dbo.GetMaterialTypeTreeFromParentByID(67, Default, Default, Default) As MaterialTypeInfo
On Material.MaterialTypeLink = MaterialTypeInfo.MaterialTypeID

Select *
From CmdProd_SONAG_RJ.dbo.icst As ICST
Left Join Data_Import_RJ.dbo.TestImport0000_XML_MaterialInfo As MaterialInfo
On	dbo.TrimNVarChar(ICST.loc_code) =  dbo.TrimNVarChar(MaterialInfo.PlantName) And
	dbo.TrimNVarChar(ICST.const_item_code) = dbo.TrimNVarChar(MaterialInfo.ItemCode)
Where MaterialInfo.AutoID Is Null

Select CategoryInfo.item_type
From CmdProd_SONAG_RJ.dbo.icst As Recipe
Inner Join CmdProd_SONAG_RJ.dbo.imst As MainInfo
On MainInfo.item_code = Recipe.item_code
Inner Join CmdProd_SONAG_RJ.dbo.icat As CategoryInfo
On CategoryInfo.item_cat = MainInfo.item_cat
Group By CategoryInfo.item_type

Select CategoryInfo.item_cat, CategoryInfo.descr, CategoryInfo.short_descr, CategoryInfo.item_type, CategoryInfo.matl_type
From CmdProd_SONAG_RJ.dbo.icst As Recipe
Inner Join CmdProd_SONAG_RJ.dbo.imst As MainInfo
On MainInfo.item_code = Recipe.item_code
Inner Join CmdProd_SONAG_RJ.dbo.icat As CategoryInfo
On CategoryInfo.item_cat = MainInfo.item_cat
Group By CategoryInfo.item_cat, CategoryInfo.descr, CategoryInfo.short_descr, CategoryInfo.item_type, CategoryInfo.matl_type
Order By CategoryInfo.item_cat

Select CategoryInfo.item_cat, CategoryInfo.descr, CategoryInfo.short_descr, CategoryInfo.item_type, CategoryInfo.matl_type
From CmdProd_SONAG_RJ.dbo.icst As Recipe
Inner Join CmdProd_SONAG_RJ.dbo.imst As MainInfo
On MainInfo.item_code = Recipe.const_item_code
Inner Join CmdProd_SONAG_RJ.dbo.icat As CategoryInfo
On CategoryInfo.item_cat = MainInfo.item_cat
Group By CategoryInfo.item_cat, CategoryInfo.descr, CategoryInfo.short_descr, CategoryInfo.item_type, CategoryInfo.matl_type
Order By CategoryInfo.item_cat

Select	Ltrim(Rtrim(CategoryInfo.item_cat)),
		Ltrim(Rtrim(CategoryInfo.descr)),
		Ltrim(Rtrim(CategoryInfo.short_descr)),
		Ltrim(Rtrim(CategoryInfo.item_type))
From CmdProd_SONAG_RJ.dbo.icat As CategoryInfo
Where Ltrim(Rtrim(CategoryInfo.item_type)) = '01'
Order By CategoryInfo.item_cat

Select *
From Data_Import_RJ.dbo.TestImport0000_XML_MixItemCategory As CategoryInfo
Order By CategoryInfo.AutoID

Select MainInfo.air_pct
From CmdProd_SONAG_RJ.dbo.imst As MainInfo
Where MainInfo.air_pct Is Not Null

Select PlantInfo.air_pct
From CmdProd_SONAG_RJ.dbo.iloc As PlantInfo
Where PlantInfo.air_pct Is Not Null

Select *
From CmdProd_SONAG_RJ.dbo.uoms As MeasInfo

Select ICST.*
From CmdProd_SONAG_RJ.dbo.ICST As ICST
Left Join CmdProd_SONAG_RJ.dbo.iloc As ILOC
On	LTrim(RTrim(ILOC.loc_code)) = LTrim(RTrim(ICST.loc_code)) And
	LTrim(RTrim(ILOC.item_code)) = LTrim(RTrim(ICST.const_item_code))
Where Iloc.item_code Is Null

Select ICST.*
From CmdProd_SONAG_RJ.dbo.ICST As ICST
Left Join CmdProd_SONAG_RJ.dbo.imst As IMST
On	LTrim(RTrim(icst.const_item_code)) = LTrim(RTrim(IMST.item_code))
Where IMST.item_code Is Null

Select MixInfo.QuantityUnitName, Count(*)
From Data_Import_RJ.dbo.TestImport0000_XML_MixInfo As MixInfo
Group By MixInfo.QuantityUnitName
Order By MixInfo.QuantityUnitName

Select Ltrim(Rtrim(UOMS.descr))
From CmdProd_SONAG_RJ.dbo.icst As ICST
Inner Join CmdProd_SONAG_RJ.dbo.uoms As UOMS
On Ltrim(Rtrim(ICST.qty_uom)) = Ltrim(Rtrim(UOMS.uom))
Group By Ltrim(Rtrim(UOMS.descr))

Select Ltrim(Rtrim(ICST.qty_uom))
From CmdProd_SONAG_RJ.dbo.icst As ICST
Left Join CmdProd_SONAG_RJ.dbo.uoms As UOMS
On Ltrim(Rtrim(ICST.qty_uom)) = Ltrim(Rtrim(UOMS.uom))
Where UOMS.uom Is Null
Group By Ltrim(Rtrim(ICST.qty_uom))

Select ICSt.*
From CmdProd_SONAG_RJ.dbo.icst As ICST
Inner Join CmdProd_SONAG_RJ.dbo.uoms As UOMS
On Ltrim(Rtrim(ICST.qty_uom)) = Ltrim(Rtrim(UOMS.uom))
Where dbo.TrimNVarChar(UOMS.descr) = 'Each' 

Select Plants.Name, MixName.Name
From Sonag_RJ.dbo.Plants As Plants
Inner Join Sonag_RJ.dbo.BATCH As Mix
On Mix.Plant_Link = Plants.PlantId
Inner Join Sonag_RJ.dbo.Name As MixName
On MixName.NameID = Mix.NameID
Left Join Sonag_RJ.dbo.RptMixSpecAirContent As AirSpec
On Mix.MixSpecID = AirSpec.MixSpecID
Left Join Sonag_RJ.dbo.RptMixSpecSlump As SlumpSpec
On Mix.MixSpecID = SlumpSpec.MixSpecID
Where	Isnull(AirSpec.MinAirContent, -1.0) >= 0.0 Or
		Isnull(AirSpec.MaxAirContent, -1.0) >= 0.0 Or
		Isnull(SlumpSpec.MinSlump, -1.0) >= 0.0 Or
		Isnull(SlumpSpec.MaxSlump, -1.0) >= 0.0
Order By Plants.Name, MixName.Name

Select Count(*)
From CmdProd_SONAG_RJ.dbo.icst

Select *
From Data_Import_RJ.dbo.TestImport0000_XML_MaterialInfo As MaterialInfo
Order By MaterialInfo.AutoID

Select *
From Data_Import_RJ.dbo.TestImport0000_XML_MixInfo As MixInfo
Order By MixInfo.AutoID

Select *
From CmdProd_SONAG_RJ.dbo.locn

Select *
From Sonag_RJ.dbo.Plants

Select ICST.*
From CmdProd_SONAG_RJ.dbo.ICST As ICST
Inner Join Sonag_RJ.dbo.Plants As Plants
On dbo.TrimNVarChar(ICST.loc_code) = dbo.TrimNVarChar(Plants.Name)
Inner Join Sonag_RJ.dbo.Name As MixName
On dbo.TrimNVarChar(ICST.item_code) = dbo.TrimNVarChar(MixName.Name)
Inner Join Sonag_RJ.dbo.BATCH As Mix
On	Mix.Plant_Link = Plants.PlantId And
	Mix.NameID = MixName.NameID
Left Join 
(
	Select Material.MATERIALIDENTIFIER, Plants.Name As PlantCode, ItemName.Name As ItemCode
	From Sonag_RJ.dbo.Plants As Plants
	Inner Join Sonag_RJ.dbo.MATERIAL As Material
	On Material.PlantID = Plants.PlantId
	Inner Join Sonag_RJ.dbo.ItemMaster As ItemMaster
	On ItemMaster.ItemMasterID = Material.ItemMasterID
	Inner Join Sonag_RJ.dbo.Name As ItemName
	On ItemName.NameID = ItemMaster.NameID
) As ExistingMaterials
On	Plants.Name = ExistingMaterials.PlantCode And
	dbo.TrimNVarChar(ICST.const_item_code) = dbo.TrimNVarChar(ExistingMaterials.ItemCode)
Where ExistingMaterials.MATERIALIDENTIFIER Is Null

Select ICST.loc_code, ICST.item_code
From CmdProd_SONAG_RJ.dbo.icst As ICST
Left Join 
(
	Select Mix.BATCHIDENTIFIER As ID, Plants.Name As PlantCode, MixName.Name As ItemCode
	From Sonag_RJ.dbo.Plants As Plants
	Inner Join Sonag_RJ.dbo.BATCH As Mix
	On Mix.Plant_Link = Plants.PlantId
	Inner Join Sonag_RJ.dbo.Name As MixName
	On MixName.NameID = Mix.NameID
) As ExistingMix
On	dbo.TrimNVarChar(ICST.loc_code) = dbo.TrimNVarChar(ExistingMix.PlantCode) And
	dbo.TrimNVarChar(ICST.item_code) = dbo.TrimNVarChar(ExistingMix.ItemCode)
Where ExistingMix.ID Is Null
Group By ICST.loc_code, ICST.item_code
Order By ICST.loc_code, ICST.item_code

Select Plants.Name, MixName.Name
From Sonag_RJ.dbo.Plants As Plants
Inner Join Sonag_RJ.dbo.BATCH As Mix
On Mix.Plant_Link = Plants.PlantId
Inner Join Sonag_RJ.dbo.Name As MixName
On MixName.NameID = Mix.NameID
Inner Join
(
	Select Batch.MixNameCode
	From Sonag_RJ.dbo.BATCH As Batch
	Inner Join Sonag_RJ.dbo.TESTINFO As TestInfo
	On TestInfo.BatchID = Batch.BATCHIDENTIFIER
	Inner Join Sonag_RJ.dbo.TEST As Test
	On Test.TestInfoID = TestInfo.TESTINFOIDENTIFIER
	Group By Batch.MixNameCode
) As ExistingBatches
On ExistingBatches.MixNameCode = Mix.MixNameCode
Order By Plants.Name, MixName.Name

Select ItemCategoryInfo.ItemCategory
From Sonag_RJ.dbo.MATERIAL As Material
Inner Join Sonag_RJ.dbo.ItemMaster As ItemMaster
On ItemMaster.ItemMasterID = Material.ItemMasterID
Inner Join Sonag_RJ.dbo.ProductionItemCategory As ItemCategoryInfo
On ItemCategoryInfo.ProdItemCatID = ItemMaster.ProdItemCatID
Group By ItemCategoryInfo.ItemCategory
Order By ItemCategoryInfo.ItemCategory

Select ItemCategoryInfo.ItemCategory
From Sonag_RJ.dbo.MATERIAL As Material
Inner Join Sonag_RJ.dbo.ItemMaster As ItemMaster
On ItemMaster.ItemMasterID = Material.ItemMasterID
Inner Join Sonag_RJ.dbo.ProductionItemCategory As ItemCategoryInfo
On ItemCategoryInfo.ProdItemCatID = ItemMaster.ProdItemCatID
Group By ItemCategoryInfo.ItemCategory
Having Count(Distinct Material.FamilyMaterialTypeID) > 1
Order By ItemCategoryInfo.ItemCategory

Select *
From Sonag_RJ.dbo.MATERIAL As Material
Inner Join Sonag_RJ.dbo.ItemMaster As ItemMaster
On ItemMaster.ItemMasterID = Material.ItemMasterID
Inner Join Sonag_RJ.dbo.ProductionItemCategory As ItemCategoryInfo
On ItemCategoryInfo.ProdItemCatID = ItemMaster.ProdItemCatID
Where ItemCategoryInfo.ItemCategory = 'ACCEL'
*/

Select *
From iServiceDataExchange_G2_200_RJansen.dbo.MaterialType As MaterialTypeInfo
Order By MaterialTypeInfo.RecipeOrder

    	Select	dbo.TrimNVarChar(ILOC.loc_code) As [Plant Code],
    			dbo.TrimNVarChar(IMST.item_code) As [Mix Code],
    			dbo.TrimNVarChar(IMST.descr) As [Mix Description],
    			dbo.TrimNVarChar(IMST.short_descr) As [Mix Short Description],
    			dbo.TrimNVarChar(IMST.item_cat) As [Item Category],
    			28.0 As [Strength Age],
    			IMST.strgth As [Strength],
    			IsNull(ILOC.air_pct, IMST.air_pct) As [Air Content],
    			Null As [Min Air Content],
    			Null As [Max Air Content],
    			dbo.TrimNVarChar(IMST.slump) As [Slump],
    			dbo.TrimNVarChar(IMST.min_slump) As [Min Slump],
    			dbo.TrimNVarChar(IMST.max_slump) As [Max Slump],
    			'' As [Dispatch Slump Range],
    			'' As [Padding],
    			dbo.TrimNVarChar(ICSt.const_item_code) As [Material Item Code],
    			dbo.TrimNVarChar(MtrlIMST.descr) As [Material Description],
    			IsNull(ICST.qty, 0.0),
    			dbo.TrimNVarChar(Isnull(UOMS.descr, ICST.qty_uom))
    	From CmdProd_SONAG_RJ.dbo.imst As IMST
    	Inner Join Data_Import_RJ.dbo.TestImport0000_XML_MixItemCategory As CategoryInfo
    	On dbo.TrimNVarChar(IMST.item_cat) = dbo.TrimNVarChar(CategoryInfo.Name)
    	Inner Join CmdProd_SONAG_RJ.dbo.iloc As ILOC
    	On dbo.TrimNVarChar(ILOC.item_code) = dbo.TrimNVarChar(IMST.item_code)
    	Inner Join CmdProd_SONAG_RJ.dbo.icst As ICST
    	On	dbo.TrimNVarChar(ICST.loc_code) = dbo.TrimNVarChar(ILOC.loc_code) And
    		dbo.TrimNVarChar(ICST.item_code) = dbo.TrimNVarChar(ILOC.item_code)
    	Inner Join CmdProd_SONAG_RJ.dbo.IMST As MtrlIMST
    	On dbo.TrimNVarChar(ICST.const_item_code) = dbo.TrimNVarChar(MtrlIMST.item_code)
    	Inner Join Data_Import_RJ.dbo.TestImport0000_XML_MaterialInfo As MaterialInfo
    	On	dbo.TrimNVarChar(ICST.loc_code) = dbo.TrimNVarChar(MaterialInfo.PlantName) And
    		dbo.TrimNVarChar(ICST.const_item_code) = dbo.TrimNVarChar(MaterialInfo.ItemCode)
    	Left Join
    	(
    		Select -1 As ID, dbo.TrimNVarChar(ICST.loc_code) As loc_Code, dbo.TrimNVarChar(ICST.item_code) As item_code
    		From CmdProd_SONAG_RJ.dbo.icst As ICST
    		Left Join Data_Import_RJ.dbo.TestImport0000_XML_MaterialInfo As MaterialInfo
    		On	dbo.TrimNVarChar(ICST.loc_code) = dbo.TrimNVarChar(MaterialInfo.PlantName) And
    			dbo.TrimNVarChar(ICST.const_item_code) = dbo.TrimNVarChar(MaterialInfo.ItemCode)
    		Where MaterialInfo.AutoID Is Null
    		Group By dbo.TrimNVarChar(ICST.loc_code), dbo.TrimNVarChar(ICST.item_code)
    	) As MissingInfo
    	On	dbo.TrimNVarChar(MissingInfo.loc_code) = dbo.TrimNVarChar(ICST.loc_code) And
    		dbo.TrimNVarChar(MissingInfo.item_code) = dbo.TrimNVarChar(ICST.item_code)
    	Left Join Data_Import_RJ.dbo.TestImport0000_XML_MixInfo As ExistingMix
    	On	dbo.TrimNVarChar(ICST.loc_code) = dbo.TrimNVarChar(ExistingMix.PlantCode) And
    		dbo.TrimNVarChar(ICST.item_code) = dbo.TrimNVarChar(ExistingMix.MixCode) And
    		dbo.TrimNVarChar(ICST.const_item_code) = dbo.TrimNVarChar(ExistingMix.MaterialItemCode)
    	Left Join CmdProd_SONAG_RJ.dbo.uoms As UOMS
    	On dbo.TrimNVarChar(ICST.qty_uom) = dbo.TrimNVarChar(UOMS.uom)
    	Where	MissingInfo.ID Is Null And
    			ExistingMix.AutoID Is Null And
    			(
    				dbo.TrimNVarChar(IsNull(MaterialInfo.FamilyMaterialTypeName, '')) Not In ('Cement', 'Mineral', 'Aggregate') Or
    				dbo.TrimNVarChar(IsNull(MaterialInfo.FamilyMaterialTypeName, '')) In ('Cement', 'Mineral', 'Aggregate') And
    				Isnull(ICST.qty, -1.0) > 0.0 
    			) And dbo.TrimNVarChar(ICST.loc_code) = '7' And dbo.TrimNVarChar(ICST.item_code) = 'HULC12'
    	Order By	dbo.TrimNVarChar(ICST.loc_code),
    				dbo.TrimNVarChar(ICST.item_code),
    				dbo.TrimNVarChar(ICSt.const_item_code)

Select	IsNull(Plants.Name, '') As [Plant Name],
		IsNull(TradeName.Name, '') As [Trade Name],
		IsNull(Description.[Description], '') As [Description],
		Material.DATE As [Material Date],
		Round(CostInfo.OriginalCost, 2) As [Original Cost],
		Round(CostInfo.ConvertedCost, 2) As [Cost ($/MTon)],
		Isnull(CostInfo.ConvertedCostUnits, '') As [Cost Units],
		Round(Material.SPECGR, 4) As [Specific Gravity],
		Round(Material.SPECHT, 4) As [Specific Heat],
		Round(Material.MOISTURE * 100.0, 2) As [Moisture (%)],
		Round(Material.BLAINE, 2) As [Blaine Fineness (m^2/kg)], -- * 4.88242763638305 (ft^2/lb) US Info
		IsNull(Manufacturer.Name, '') As [Manufacturer],
		IsNull(ManufacturerSource.Name, '') As [Manufacturer Source],
		IsNull(FamilyMaterialType.MaterialType, '') As [Family Material Type],
		IsNull(MaterialType.MaterialType, '') As [Material Type],
		IsNull(Material.[TYPE], '') As [Report Material Type],
		IsNull(ItemName.Name, '') As [Item Code],
		IsNull(ItemDescription.[Description], '') As [Item Description],
		IsNull(ItemMaster.ItemShortDescription, '') As [Item Short Description],
		IsNull(ItemCategory.ItemCategory, '') As [Item Category],
		IsNull(ComponentCategory.ItemCategory, '') As [Component Category],
		IsNull(BatchPanelName.Name, '') As [Batch Panel Code],
		IsNull(Material.BatchPanelDescription, '') As [Batch Panel Description]
From dbo.Plants As Plants
Inner Join dbo.MATERIAL As Material
On Material.PlantID = Plants.PlantId
Inner Join dbo.Name As TradeName
On TradeName.NameID = Material.NameID
Left Join dbo.[Description] As Description
On Description.DescriptionID = Material.DescriptionID
Left Join dbo.Manufacturer As Manufacturer
On Manufacturer.ManufacturerID = Material.ManufacturerID
Left Join dbo.ManufacturerSource As ManufacturerSource
On ManufacturerSource.ManufacturerSourceID = Material.ManufacturerSourceID  
Left Join iServiceDataExchange.dbo.MaterialType As FamilyMaterialType
On Material.FamilyMaterialTypeID = FamilyMaterialType.MaterialTypeID
Left Join iServiceDataExchange.dbo.MaterialType As MaterialType
On Material.MaterialTypeLink = MaterialType.MaterialTypeID
Left Join dbo.ItemMaster As ItemMaster
On ItemMaster.ItemMasterID = Material.ItemMasterID
Left Join dbo.Name As ItemName
On ItemName.NameID = ItemMaster.NameID
Left Join dbo.[Description] As ItemDescription
On ItemDescription.DescriptionID = ItemMaster.DescriptionID
Left Join dbo.ProductionItemCategory As ItemCategory
On ItemCategory.ProdItemCatID = ItemMaster.ProdItemCatID
Left Join dbo.ProductionItemCategory As ComponentCategory
On ComponentCategory.ProdItemCatID = ItemMaster.ProdItemCompTypeID
Left Join dbo.Name As BatchPanelName
On BatchPanelName.NameID = Material.BatchPanelNameID
Left Join dbo.GetMaterialConvertedCostsByUnitSys(Null, dbo.GetMaterialCostsAreRetrievedFromHistory(), Null, Null, dbo.GetDBSetting_MaterialHistoryCostsDefaultHistoryPeriod(Default), Null, 2) As CostInfo
On Material.MATERIALIDENTIFIER = CostInfo.MaterialID
Where ItemCategory.ItemCategory = 'WATER'
Order By Plants.Name, TradeName.Name

Select ItemMaster.NameID
From dbo.MATERIAL As Material
Inner Join dbo.ItemMaster As ItemMaster
On ItemMaster.ItemMasterID = Material.ItemMasterID
Group By ItemMaster.NameID
Having Count(Distinct Material.FamilyMaterialTypeID) > 0

Select *
From Data_Import_RJ.dbo.TestImport0000_XML_MainMaterialInfo As MaterialInfo
Where   MaterialInfo.Name Not In
        (
	        Select Name.Name
	        From dbo.MATERIAL As Material
	        Inner Join dbo.ItemMaster As ItemMaster
	        On ItemMaster.ItemMasterID = Material.ItemMasterID
	        Inner Join dbo.Name As Name
	        On Name.NameID = ItemMaster.NameID
        )

Select *
From Data_Import_RJ.dbo.TestImport0000_XML_MaterialInfo As MaterialInfo
Order By MaterialInfo.PlantName, MaterialInfo.TradeName

Select MaterialInfo.PlantName, MaterialInfo.TradeName,Count(*)
From Data_Import_RJ.dbo.TestImport0000_XML_MaterialInfo As MaterialInfo
Group By MaterialInfo.PlantName, MaterialInfo.TradeName
Having Count(*) > 1
Order By MaterialInfo.PlantName, MaterialInfo.TradeName

Select *
From CmdProd_Sonag_RJ.dbo.icst As ICST
Left Join Data_Import_RJ.dbo.TestImport0000_XML_MaterialInfo As MaterialInfo
On  dbo.TrimNVarChar(ICST.loc_code) = dbo.TrimNVarChar(MaterialInfo.PlantName) And
    dbo.TrimNVarChar(ICST.const_item_code) = dbo.TrimNVarChar(MaterialInfo.ItemCode)
Where MaterialInfo.AutoID Is Null



Select	dbo.TrimNVarChar(ILOC.loc_code) As [Plant Code],
    	dbo.TrimNVarChar(IMST.item_code) As [Mix Code],
    	dbo.TrimNVarChar(IMST.descr) As [Mix Description],
    	dbo.TrimNVarChar(IMST.short_descr) As [Mix Short Description],
    	dbo.TrimNVarChar(IMST.item_cat) As [Item Category],
    	28.0 As [Strength Age],
    	IMST.strgth As [Strength],
    	IsNull(ILOC.air_pct, IMST.air_pct) As [Air Content],
    	Null As [Min Air Content],
    	Null As [Max Air Content],
    	dbo.TrimNVarChar(IMST.slump) As [Slump],
    	dbo.TrimNVarChar(IMST.min_slump) As [Min Slump],
    	dbo.TrimNVarChar(IMST.max_slump) As [Max Slump],
    	'' As [Dispatch Slump Range],
    	'' As [Padding],
    	dbo.TrimNVarChar(ICSt.const_item_code) As [Material Item Code],
    	dbo.TrimNVarChar(MtrlIMST.descr) As [Material Description],
    	IsNull(ICST.qty, 0.0),
    	dbo.TrimNVarChar(Isnull(UOMS.descr, ICST.qty_uom))
From CmdProd_SONAG_RJ.dbo.imst As IMST
Inner Join Data_Import_RJ.dbo.TestImport0000_XML_MixItemCategory As CategoryInfo
On dbo.TrimNVarChar(IMST.item_cat) = dbo.TrimNVarChar(CategoryInfo.Name)
Inner Join CmdProd_SONAG_RJ.dbo.iloc As ILOC
On dbo.TrimNVarChar(ILOC.item_code) = dbo.TrimNVarChar(IMST.item_code)
Inner Join CmdProd_SONAG_RJ.dbo.icst As ICST
On	dbo.TrimNVarChar(ICST.loc_code) = dbo.TrimNVarChar(ILOC.loc_code) And
    dbo.TrimNVarChar(ICST.item_code) = dbo.TrimNVarChar(ILOC.item_code)
Inner Join CmdProd_SONAG_RJ.dbo.IMST As MtrlIMST
On dbo.TrimNVarChar(ICST.const_item_code) = dbo.TrimNVarChar(MtrlIMST.item_code)
Inner Join Data_Import_RJ.dbo.TestImport0000_XML_MaterialInfo As MaterialInfo
On	dbo.TrimNVarChar(ICST.loc_code) = dbo.TrimNVarChar(MaterialInfo.PlantName) And
    dbo.TrimNVarChar(ICST.const_item_code) = dbo.TrimNVarChar(MaterialInfo.ItemCode)
Left Join
(
    Select -1 As ID, dbo.TrimNVarChar(ICST.loc_code) As loc_Code, dbo.TrimNVarChar(ICST.item_code) As item_code
    From CmdProd_SONAG_RJ.dbo.icst As ICST
    Left Join Data_Import_RJ.dbo.TestImport0000_XML_MaterialInfo As MaterialInfo
    On	dbo.TrimNVarChar(ICST.loc_code) = dbo.TrimNVarChar(MaterialInfo.PlantName) And
    	dbo.TrimNVarChar(ICST.const_item_code) = dbo.TrimNVarChar(MaterialInfo.ItemCode)
    Where MaterialInfo.AutoID Is Null
    Group By dbo.TrimNVarChar(ICST.loc_code), dbo.TrimNVarChar(ICST.item_code)
) As MissingInfo
On	dbo.TrimNVarChar(MissingInfo.loc_code) = dbo.TrimNVarChar(ICST.loc_code) And
    dbo.TrimNVarChar(MissingInfo.item_code) = dbo.TrimNVarChar(ICST.item_code)
Left Join Data_Import_RJ.dbo.TestImport0000_XML_MixInfo As ExistingMix
On	dbo.TrimNVarChar(ICST.loc_code) = dbo.TrimNVarChar(ExistingMix.PlantCode) And
    dbo.TrimNVarChar(ICST.item_code) = dbo.TrimNVarChar(ExistingMix.MixCode) And
    dbo.TrimNVarChar(ICST.const_item_code) = dbo.TrimNVarChar(ExistingMix.MaterialItemCode)
Left Join CmdProd_SONAG_RJ.dbo.uoms As UOMS
On dbo.TrimNVarChar(ICST.qty_uom) = dbo.TrimNVarChar(UOMS.uom)
Where	MissingInfo.ID Is Null And
    	--ExistingMix.AutoID Is Null And
    	(
    		dbo.TrimNVarChar(IsNull(MaterialInfo.FamilyMaterialTypeName, '')) Not In ('Cement', 'Mineral', 'Aggregate') Or
    		dbo.TrimNVarChar(IsNull(MaterialInfo.FamilyMaterialTypeName, '')) In ('Cement', 'Mineral', 'Aggregate') And
    		Isnull(ICST.qty, -1.0) > 0.0 
    	) And
    	dbo.TrimNVarChar(ILOC.loc_code) = '1' And dbo.TrimNVarChar(ILOC.item_code) = '(71808)'
Order By	dbo.TrimNVarChar(ICST.loc_code),
    		dbo.TrimNVarChar(ICST.item_code),
    		dbo.TrimNVarChar(ICSt.const_item_code)
          