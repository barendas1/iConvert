/*
SELECT        PlantName, TradeName, MaterialDate, FamilyMaterialTypeName, MaterialTypeName, SpecificGravity, IsLiquidAdmix, MoisturePct, Cost, CostUnitName, ManufacturerName, ManufacturerSourceName, ItemCode, 
                         ItemDescription, ItemCategoryName, ItemCategoryDescription, ItemCategoryShortDescription, BatchPanelCode
FROM            TestImport0000_XML_MaterialInfo

SELECT        PlantName, TradeName, MaterialDate, FamilyMaterialTypeName, MaterialTypeName, SpecificGravity, IsLiquidAdmix, MoisturePct, Cost, CostUnitName, ManufacturerName, ManufacturerSourceName, ItemCode, 
                         ItemDescription, ItemCategoryName, ItemCategoryDescription, ItemCategoryShortDescription, BatchPanelCode
FROM            Import01_MaterialInfo_WCAN

SELECT        PlantCode, MixCode, MixDescription, MixShortDescription, ItemCategory, StrengthAge, Strength, AirContent, MinAirContent, MaxAirContent, Slump, MinSlump, MaxSlump, Padding1, MaterialItemCode, 
                         MaterialItemDescription, Quantity, QuantityUnitName
FROM            TestImport0000_XML_MixInfo

SELECT        PlantCode, MixCode, MixDescription, MixShortDescription, ItemCategory, StrengthAge, Strength, AirContent, MinAirContent, MaxAirContent, Slump, MinSlump, MaxSlump, Padding1, MaterialItemCode, 
                         MaterialItemDescription, Quantity, QuantityUnitName
FROM            Import01_ImportMixInfo_WCAN
*/

Select *
From iServiceDataExchange.dbo.MaterialType As MtrlType
Order By MtrlType.RecipeOrder

Select *
From Data_Import_RJ.dbo.TestImport0000_XML_MaterialInfo As MaterialInfo
Inner Join 
(
    Select Plants.Name As PlantCode, TradeNameInfo.Name As TradeName, ItemName.Name As ItemCode, Material.SPECGR As SpecificGravity 
    From dbo.Plants As Plants
    Inner Join dbo.MATERIAL As Material
    On Material.PlantID = Plants.PlantId
    Inner Join dbo.Name As TradeNameInfo
    On TradeNameInfo.NameID = Material.NameID
    Inner Join dbo.ItemMaster As ItemMaster
    On ItemMaster.ItemMasterID = Material.ItemMasterID
    Inner Join dbo.Name As ItemName
    On ItemName.NameID = ItemMaster.NameID	
) As CurMaterialInfo
On MaterialInfo.PlantName = CurMaterialInfo.PlantCode And MaterialInfo.ItemCode = CurMaterialInfo.ItemCode
Where Isnull(MaterialInfo.SpecificGravity, -1.0) <> Isnull(CurMaterialInfo.SpecificGravity, -1.0)

Select *
From Data_Import_RJ.dbo.TestImport0000_XML_MaterialInfo As MaterialInfo
Inner Join 
(
    Select Plants.Name As PlantCode, TradeNameInfo.Name As TradeName, ItemName.Name As ItemCode, Material.SPECGR As SpecificGravity 
    From dbo.Plants As Plants
    Inner Join dbo.MATERIAL As Material
    On Material.PlantID = Plants.PlantId
    Inner Join dbo.Name As TradeNameInfo
    On TradeNameInfo.NameID = Material.NameID
    Inner Join dbo.ItemMaster As ItemMaster
    On ItemMaster.ItemMasterID = Material.ItemMasterID
    Inner Join dbo.Name As ItemName
    On ItemName.NameID = ItemMaster.NameID	
) As CurMaterialInfo
On MaterialInfo.PlantName = CurMaterialInfo.PlantCode And MaterialInfo.ItemCode = CurMaterialInfo.ItemCode
Where Isnull(MaterialInfo.SpecificGravity, -1.0) = Isnull(CurMaterialInfo.SpecificGravity, -1.0)

Select *
From Data_Import_RJ.dbo.TestImport0000_XML_MaterialInfo As MaterialInfo

Select *
From Data_Import_RJ.dbo.TestImport0000_XML_MaterialInfo As MaterialInfo
Where MaterialInfo.ItemCode = 'MEDSAND'

Select Distinct MaterialInfo.Cost
From Data_Import_RJ.dbo.TestImport0000_XML_MaterialInfo As MaterialInfo

Select Distinct MaterialInfo.CostUnitName
From Data_Import_RJ.dbo.TestImport0000_XML_MaterialInfo As MaterialInfo

Select *
From Data_Import_RJ.dbo.TestImport0000_XML_MaterialInfo As MaterialInfo
Left Join Sonag_RJ.dbo.Name As MtrlName
On MaterialInfo.BatchPanelCode = MtrlName.Name
Where MtrlName.NameID Is Null

Select Plants.Name, TradeNameInfo.Name, Cast(Material.DATE As Datetime), Count(*)
From dbo.Plants As Plants
Inner Join dbo.MATERIAL As Material
On Material.PlantID = Plants.PlantId
Inner Join dbo.Name As TradeNameInfo
On TradeNameInfo.NameID = Material.NameID
Left Join dbo.ItemMaster As ItemMaster
On ItemMaster.ItemMasterID = Material.ItemMasterID
Left Join dbo.Name As ItemName
On ItemName.NameID = ItemMaster.NameID
Group By Plants.Name, TradeNameInfo.Name, Cast(Material.DATE As Datetime)
Having Count(*) > 1
Order By Plants.Name, TradeNameInfo.Name

Select Plants.Name, TradeNameInfo.Name, Min(IsNull(ItemName.Name, '')), Max(IsNull(ItemName.Name, '')), Count(*)
From dbo.Plants As Plants
Inner Join dbo.MATERIAL As Material
On Material.PlantID = Plants.PlantId
Inner Join dbo.Name As TradeNameInfo
On TradeNameInfo.NameID = Material.NameID
Left Join dbo.ItemMaster As ItemMaster
On ItemMaster.ItemMasterID = Material.ItemMasterID
Left Join dbo.Name As ItemName
On ItemName.NameID = ItemMaster.NameID
Group By Plants.Name, TradeNameInfo.Name
Having Count(Distinct Isnull(ItemName.Name, '')) > 1
Order By Plants.Name, TradeNameInfo.Name

Select Plants.Name As PlantCode, ItemName.Name As ItemCode, Min(IsNull(TradeNameInfo.Name, '')) As TradeName1, Max(IsNull(TradeNameInfo.Name, '')) As TradeName2, Count(*)
From dbo.Plants As Plants
Inner Join dbo.MATERIAL As Material
On Material.PlantID = Plants.PlantId
Inner Join dbo.Name As TradeNameInfo
On TradeNameInfo.NameID = Material.NameID
Left Join dbo.ItemMaster As ItemMaster
On ItemMaster.ItemMasterID = Material.ItemMasterID
Left Join dbo.Name As ItemName
On ItemName.NameID = ItemMaster.NameID
Where Isnull(ItemName.Name, '') <> ''
Group By Plants.Name, ItemName.Name
Having Count(Distinct Isnull(TradeNameInfo.Name, '')) > 1
Order By Plants.Name, ItemName.Name

Select Material.PlantID, Material.NameID
From dbo.MATERIAL As Material
Where Material.FamilyMaterialTypeID Is Not Null
Group By Material.PlantID, Material.NameID
Having Count(*) > 1

Select Material.PlantID, Material.ItemMasterID, Count(*)
From dbo.MATERIAL As Material
Where Material.FamilyMaterialTypeID Is Not null
Group By Material.PlantID, Material.ItemMasterID
Having Count(*) > 1

Select MaterialInfo.*
From Data_Import_RJ.dbo.TestImport0000_XML_MaterialInfo As MaterialInfo
Left Join 
(
	Select -1 As ID, Plants.Name As PlantCode, ItemName.Name As ItemCode
	From dbo.Plants As Plants
	Inner Join dbo.MATERIAL As Material
	On Material.PlantID = Plants.PlantId
	Inner Join dbo.ItemMaster As ItemMaster
	On ItemMaster.ItemMasterID = Material.ItemMasterID
	Inner Join dbo.Name As ItemName
	On ItemName.NameID = ItemMaster.NameID
	Group By Plants.Name, ItemName.Name
) As ExistingInfo
On	MaterialInfo.PlantName = ExistingInfo.PlantCode And
	MaterialInfo.ItemCode = ExistingInfo.ItemCode 
Where ExistingInfo.ID Is Null
Order By MaterialInfo.AutoID
/*
5,
6,
7,
8,
104,
108,
226,
237
5, 6, 7, 8, 104, 108, 226, 237
*/
Select	Info.UploadFileName, Info.[Description], Info.NameOfFileWritten,
      	Info.NameOfLogRead, Info.UsedForMtrls, Info.UsedForMixes,
      	Line.FieldName, Line.BeginPos, Line.EndPos, Line.[Required],
      	Line.DefaultValue
From CANEST_Quadrel_PROD_RJ.dbo.UploadFormat As Info
Inner Join CANEST_Quadrel_PROD_RJ.dbo.UploadLineFormat As Line
On Info.UploadFormatID = Line.UploadFormatID
Order by Info.UploadFileName, Line.BeginPos

Delete from dbo.UploadLineFormat
Delete from dbo.UploadFormat

Set Identity_insert dbo.UploadFormat On

Insert into dbo.UploadFormat
(
	UploadFormatID, -- this column value is auto-generated
	UploadFileName,
	[Description],
	NameOfFileWritten,
	NameOfLogRead,
	UsedForMtrls,
	UsedForMixes
)
Select  UploadFormat.UploadFormatID,
        UploadFormat.UploadFileName,
        UploadFormat.[Description],
        UploadFormat.NameOfFileWritten,
        UploadFormat.NameOfLogRead,
        UploadFormat.UsedForMtrls,
        UploadFormat.UsedForMixes
    From CANWST_Quadrel_PROD_RJ.dbo.UploadFormat As UploadFormat

Set Identity_insert dbo.UploadFormat Off

Set Identity_insert dbo.UploadLineFormat On

Insert into dbo.UploadLineFormat
(
	UploadLineFormatID, -- this column value is auto-generated
	UploadFormatID,
	FieldName,
	BeginPos,
	EndPos,
	[Required],
	DefaultValue
)
Select  UploadLineFormat.UploadLineFormatID,
        UploadLineFormat.UploadFormatID,
        UploadLineFormat.FieldName,
        UploadLineFormat.BeginPos,
        UploadLineFormat.EndPos,
        UploadLineFormat.[Required],
        UploadLineFormat.DefaultValue
From CANWST_Quadrel_PROD_RJ.dbo.UploadLineFormat As UploadLineFormat

Set Identity_insert dbo.UploadLineFormat Off

Select *
From iServiceDataExchange.dbo.StandardsOrg

Update StandardsOrgInfo
	Set StandardsOrgInfo.IsActive = 1
From dbo.StandardsOrgInfo As StandardsOrgInfo
Inner Join iServiceDataExchange.dbo.StandardsOrg As StandardsOrg
On StandardsOrg.StandardsOrgID = StandardsOrgInfo.StandardsOrgID
Where StandardsOrg.StandardsOrgName = 'CSA'

Update StandardInfo	
	Set StandardInfo.IsActive = 1
From dbo.StandardInfo As StandardInfo
Inner Join iServiceDataExchange.dbo.[Standard] As Standard
On Standard.StandardID = StandardInfo.StandardID
Inner Join iServiceDataExchange.dbo.StandardsOrg As StandardsOrg
On StandardsOrg.StandardsOrgID = Standard.StandardsOrg_Link
Where StandardsOrg.StandardsOrgName = 'CSA'

Select	Plants.Name, MixName.Name, Mix.AIR, ImportInfo.AirContent
From dbo.Plants As Plants
Inner Join dbo.BATCH As Mix
On Mix.Plant_Link = Plants.PlantId
Inner Join dbo.Name As MixName
On MixName.NameID = Mix.NameID
Inner Join Data_Import_RJ.dbo.TestImport0000_XML_MixInfo As ImportInfo
On	Plants.Name = ImportInfo.PlantCode And
	MixName.Name = ImportInfo.MixCode
Where	ImportInfo.AutoID In
		(
			Select Min(ImportInfo.AutoID)
			From Data_Import_RJ.dbo.TestImport0000_XML_MixInfo As ImportInfo
			Group By ImportInfo.PlantCode, ImportInfo.MixCode
		) And
		Isnull(Mix.AIR, -1.0) <> Isnull(ImportInfo.AirContent, -1.0)
Order By Plants.Name, MixName.Name

Select	Plants.Name, MixName.Name, Mix.SLUMP, ImportInfo.Slump
From dbo.Plants As Plants
Inner Join dbo.BATCH As Mix
On Mix.Plant_Link = Plants.PlantId
Inner Join dbo.Name As MixName
On MixName.NameID = Mix.NameID
Inner Join Data_Import_RJ.dbo.Import01_ImportMixInfo_WCAN As ImportInfo
On	Plants.Name = ImportInfo.PlantCode And
	MixName.Name = ImportInfo.MixCode
Where	ImportInfo.AutoID In
		(
			Select Min(ImportInfo.AutoID)
			From Data_Import_RJ.dbo.Import01_ImportMixInfo_WCAN As ImportInfo
			Group By ImportInfo.PlantCode, ImportInfo.MixCode
		) And
		Isnull(Mix.SLUMP, -1.0) <> Isnull(ImportInfo.Slump, -1.0)
Order By Plants.Name, MixName.Name

Select		Plants.Name, 
			MixName.Name, 
			AirSpec.MinAirContent, 
			AirSpec.MaxAirContent,
			ImportInfo.MinAirContent, 
			ImportInfo.MaxAirContent
From dbo.Plants As Plants
Inner Join dbo.BATCH As Mix
On Mix.Plant_Link = Plants.PlantId
Inner Join dbo.Name As MixName
On MixName.NameID = Mix.NameID
Left Join dbo.RptMixSpecAirContent As AirSpec
On Mix.MixSpecID = AirSpec.MixSpecID
Inner Join Data_Import_RJ.dbo.TestImport0000_XML_MixInfo As ImportInfo
On	Plants.Name = ImportInfo.PlantCode And
	MixName.Name = ImportInfo.MixCode
Where	ImportInfo.AutoID In
		(
			Select Min(ImportInfo.AutoID)
			From Data_Import_RJ.dbo.TestImport0000_XML_MixInfo As ImportInfo
			Group By ImportInfo.PlantCode, ImportInfo.MixCode
		) And
		(
			Isnull(AirSpec.MinAirContent, -1.0) <> Isnull(ImportInfo.MinAirContent, -1.0) Or
			Isnull(AirSpec.MaxAirContent, -1.0) <> Isnull(ImportInfo.MaxAirContent, -1.0)
		) 
Order By Plants.Name, MixName.Name

Select		Plants.Name, 
			MixName.Name, 
			SlumpSpec.MinSlump, 
			SlumpSpec.MaxSlump,
			ImportInfo.MinSlump, 
			ImportInfo.MaxSlump
From dbo.Plants As Plants
Inner Join dbo.BATCH As Mix
On Mix.Plant_Link = Plants.PlantId
Inner Join dbo.Name As MixName
On MixName.NameID = Mix.NameID
Left Join dbo.RptMixSpecSlump As SlumpSpec
On Mix.MixSpecID = SlumpSpec.MixSpecID
Inner Join Data_Import_RJ.dbo.TestImport0000_XML_MixInfo As ImportInfo
On	Plants.Name = ImportInfo.PlantCode And
	MixName.Name = ImportInfo.MixCode
Where	ImportInfo.AutoID In
		(
			Select Min(ImportInfo.AutoID)
			From Data_Import_RJ.dbo.TestImport0000_XML_MixInfo As ImportInfo
			Group By ImportInfo.PlantCode, ImportInfo.MixCode
		) And
		(
			Isnull(SlumpSpec.MinSlump, -1.0) <> Isnull(ImportInfo.MinSlump, -1.0) Or
			Isnull(SlumpSpec.MaxSlump, -1.0) <> Isnull(ImportInfo.MaxSlump, -1.0)
		) 
Order By Plants.Name, MixName.Name

Select		Plants.Name, 
			MixName.Name, 
			StrengthSpec.AgeMinValue, 
			StrengthSpec.StrengthMinValue,			
			ImportInfo.StrengthAge, 
			ImportInfo.Strength
From dbo.Plants As Plants
Inner Join dbo.BATCH As Mix
On Mix.Plant_Link = Plants.PlantId
Inner Join dbo.Name As MixName
On MixName.NameID = Mix.NameID
Left Join dbo.RptMixSpecAgeComprStrengths As StrengthSpec
On Mix.MixSpecID = StrengthSpec.MixSpecID
Inner Join Data_Import_RJ.dbo.TestImport0000_XML_MixInfo As ImportInfo
On	Plants.Name = ImportInfo.PlantCode And
	MixName.Name = ImportInfo.MixCode
Where	ImportInfo.AutoID In
		(
			Select Min(ImportInfo.AutoID)
			From Data_Import_RJ.dbo.TestImport0000_XML_MixInfo As ImportInfo
			Group By ImportInfo.PlantCode, ImportInfo.MixCode
		) And
		(
			Isnull(StrengthSpec.AgeMinValue, -1.0) <> Isnull(ImportInfo.StrengthAge, -1.0) Or
			Isnull(StrengthSpec.StrengthMinValue, -1.0) <> Isnull(ImportInfo.Strength, -1.0)
		) 
Order By Plants.Name, MixName.Name

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
From CANEST_Quadrel_PROD_RJ.dbo.Plants As Plants
Inner Join CANEST_Quadrel_PROD_RJ.dbo.MATERIAL As Material
On Material.PlantID = Plants.PlantId
Inner Join CANEST_Quadrel_PROD_RJ.dbo.Name As TradeName
On TradeName.NameID = Material.NameID
Left Join CANEST_Quadrel_PROD_RJ.dbo.[Description] As Description
On Description.DescriptionID = Material.DescriptionID
Left Join CANEST_Quadrel_PROD_RJ.dbo.Manufacturer As Manufacturer
On Manufacturer.ManufacturerID = Material.ManufacturerID
Left Join CANEST_Quadrel_PROD_RJ.dbo.ManufacturerSource As ManufacturerSource
On ManufacturerSource.ManufacturerSourceID = Material.ManufacturerSourceID  
Left Join iServiceDataExchange.dbo.MaterialType As FamilyMaterialType
On Material.FamilyMaterialTypeID = FamilyMaterialType.MaterialTypeID
Left Join iServiceDataExchange.dbo.MaterialType As MaterialType
On Material.MaterialTypeLink = MaterialType.MaterialTypeID
Left Join CANEST_Quadrel_PROD_RJ.dbo.ItemMaster As ItemMaster
On ItemMaster.ItemMasterID = Material.ItemMasterID
Left Join CANEST_Quadrel_PROD_RJ.dbo.Name As ItemName
On ItemName.NameID = ItemMaster.NameID
Left Join CANEST_Quadrel_PROD_RJ.dbo.[Description] As ItemDescription
On ItemDescription.DescriptionID = ItemMaster.DescriptionID
Left Join CANEST_Quadrel_PROD_RJ.dbo.ProductionItemCategory As ItemCategory
On ItemCategory.ProdItemCatID = ItemMaster.ProdItemCatID
Left Join CANEST_Quadrel_PROD_RJ.dbo.ProductionItemCategory As ComponentCategory
On ComponentCategory.ProdItemCatID = ItemMaster.ProdItemCompTypeID
Left Join CANEST_Quadrel_PROD_RJ.dbo.Name As BatchPanelName
On BatchPanelName.NameID = Material.BatchPanelNameID
Left Join CANEST_Quadrel_PROD_RJ.dbo.GetMaterialConvertedCostsByUnitSys(Null, CANEST_Quadrel_PROD_RJ.dbo.GetMaterialCostsAreRetrievedFromHistory(), Null, Null, CANEST_Quadrel_PROD_RJ.dbo.GetDBSetting_MaterialHistoryCostsDefaultHistoryPeriod(Default), Null, 2) As CostInfo
On Material.MATERIALIDENTIFIER = CostInfo.MaterialID
Order By Plants.Name, TradeName.Name

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
From CANEST_Quadrel_Test_RJ.dbo.Plants As Plants
Inner Join CANEST_Quadrel_Test_RJ.dbo.MATERIAL As Material
On Material.PlantID = Plants.PlantId
Inner Join CANEST_Quadrel_Test_RJ.dbo.Name As TradeName
On TradeName.NameID = Material.NameID
Left Join CANEST_Quadrel_Test_RJ.dbo.[Description] As Description
On Description.DescriptionID = Material.DescriptionID
Left Join CANEST_Quadrel_Test_RJ.dbo.Manufacturer As Manufacturer
On Manufacturer.ManufacturerID = Material.ManufacturerID
Left Join CANEST_Quadrel_Test_RJ.dbo.ManufacturerSource As ManufacturerSource
On ManufacturerSource.ManufacturerSourceID = Material.ManufacturerSourceID  
Left Join iServiceDataExchange.dbo.MaterialType As FamilyMaterialType
On Material.FamilyMaterialTypeID = FamilyMaterialType.MaterialTypeID
Left Join iServiceDataExchange.dbo.MaterialType As MaterialType
On Material.MaterialTypeLink = MaterialType.MaterialTypeID
Left Join CANEST_Quadrel_Test_RJ.dbo.ItemMaster As ItemMaster
On ItemMaster.ItemMasterID = Material.ItemMasterID
Left Join CANEST_Quadrel_Test_RJ.dbo.Name As ItemName
On ItemName.NameID = ItemMaster.NameID
Left Join CANEST_Quadrel_Test_RJ.dbo.[Description] As ItemDescription
On ItemDescription.DescriptionID = ItemMaster.DescriptionID
Left Join CANEST_Quadrel_Test_RJ.dbo.ProductionItemCategory As ItemCategory
On ItemCategory.ProdItemCatID = ItemMaster.ProdItemCatID
Left Join CANEST_Quadrel_Test_RJ.dbo.ProductionItemCategory As ComponentCategory
On ComponentCategory.ProdItemCatID = ItemMaster.ProdItemCompTypeID
Left Join CANEST_Quadrel_Test_RJ.dbo.Name As BatchPanelName
On BatchPanelName.NameID = Material.BatchPanelNameID
Left Join CANEST_Quadrel_Test_RJ.dbo.GetMaterialConvertedCostsByUnitSys(Null, CANEST_Quadrel_Test_RJ.dbo.GetMaterialCostsAreRetrievedFromHistory(), Null, Null, CANEST_Quadrel_Test_RJ.dbo.GetDBSetting_MaterialHistoryCostsDefaultHistoryPeriod(Default), Null, 2) As CostInfo
On Material.MATERIALIDENTIFIER = CostInfo.MaterialID
Inner Join
(
	Select MixInfo.PlantCode, MixInfo.MaterialItemCode
	From Data_Import_RJ.dbo.TestImport0000_XML_MixInfo As MixInfo
	Group By MixInfo.PlantCode, MixInfo.MaterialItemCode
) As RecipeInfo
On	Plants.Name = RecipeInfo.PlantCode And
	ItemName.Name = RecipeInfo.MaterialItemCode
Order By Plants.Name, TradeName.Name

Select	Plants.Name,
		TradeName.Name,
		Material.DATE,
		FamilyMaterialType.MaterialType,
		MaterialType.MaterialType,
		Material.SPECGR,
		Case
			When IsNull(Material.FamilyMaterialTypeID, -1) = 3 And Isnull(Material.MOISTURE, -1.0) > 0.0
			Then 'Yes'
			Else 'No'
		End,
		Material.MOISTURE * 100.0,
		CostInfo.ConvertedCost, 
		CostInfo.ConvertedCostUnits,
		Manufacturer.Name,
		ManufacturerSource.Name,
		Material.BatchingOrder,
		ItemName.Name,
		ItemDescription.[Description],
		ItemCategory.ItemCategory,
		ItemCategory.[Description],
		ItemCategory.ShortDescription,
		BatchPanelName.Name
From CANEST_Quadrel_Test_RJ.dbo.Plants As Plants
Inner Join CANEST_Quadrel_Test_RJ.dbo.MATERIAL As Material
On Material.PlantID = Plants.PlantId
Inner Join CANEST_Quadrel_Test_RJ.dbo.Name As TradeName
On TradeName.NameID = Material.NameID
Left Join CANEST_Quadrel_Test_RJ.dbo.[Description] As Description
On Description.DescriptionID = Material.DescriptionID
Left Join CANEST_Quadrel_Test_RJ.dbo.Manufacturer As Manufacturer
On Manufacturer.ManufacturerID = Material.ManufacturerID
Left Join CANEST_Quadrel_Test_RJ.dbo.ManufacturerSource As ManufacturerSource
On ManufacturerSource.ManufacturerSourceID = Material.ManufacturerSourceID  
Left Join iServiceDataExchange.dbo.MaterialType As FamilyMaterialType
On Material.FamilyMaterialTypeID = FamilyMaterialType.MaterialTypeID
Left Join iServiceDataExchange.dbo.MaterialType As MaterialType
On Material.MaterialTypeLink = MaterialType.MaterialTypeID
Left Join CANEST_Quadrel_Test_RJ.dbo.ItemMaster As ItemMaster
On ItemMaster.ItemMasterID = Material.ItemMasterID
Left Join CANEST_Quadrel_Test_RJ.dbo.Name As ItemName
On ItemName.NameID = ItemMaster.NameID
Left Join CANEST_Quadrel_Test_RJ.dbo.[Description] As ItemDescription
On ItemDescription.DescriptionID = ItemMaster.DescriptionID
Left Join CANEST_Quadrel_Test_RJ.dbo.ProductionItemCategory As ItemCategory
On ItemCategory.ProdItemCatID = ItemMaster.ProdItemCatID
Left Join CANEST_Quadrel_Test_RJ.dbo.ProductionItemCategory As ComponentCategory
On ComponentCategory.ProdItemCatID = ItemMaster.ProdItemCompTypeID
Left Join CANEST_Quadrel_Test_RJ.dbo.Name As BatchPanelName
On BatchPanelName.NameID = Material.BatchPanelNameID
Left Join CANEST_Quadrel_Test_RJ.dbo.GetMaterialConvertedCostsByUnitSys(Null, CANEST_Quadrel_Test_RJ.dbo.GetMaterialCostsAreRetrievedFromHistory(), Null, Null, CANEST_Quadrel_Test_RJ.dbo.GetDBSetting_MaterialHistoryCostsDefaultHistoryPeriod(Default), Null, 2) As CostInfo
On Material.MATERIALIDENTIFIER = CostInfo.MaterialID
Inner Join
(
	Select MixInfo.PlantCode, MixInfo.MaterialItemCode
	From Data_Import_RJ.dbo.TestImport0000_XML_MixInfo As MixInfo
	Group By MixInfo.PlantCode, MixInfo.MaterialItemCode
) As RecipeInfo
On	Plants.Name = RecipeInfo.PlantCode And
	ItemName.Name = RecipeInfo.MaterialItemCode
Order By Plants.Name, TradeName.Name

Select	Plants.Name,
		TradeName.Name,
		Material.DATE,
		FamilyMaterialType.MaterialType,
		MaterialType.MaterialType,
		Material.SPECGR,
		Case
			When IsNull(Material.FamilyMaterialTypeID, -1) = 3 And Isnull(Material.MOISTURE, -1.0) > 0.0
			Then 'Yes'
			Else 'No'
		End,
		Material.MOISTURE * 100.0,
		CostInfo.ConvertedCost, 
		CostInfo.ConvertedCostUnits,
		Manufacturer.Name,
		ManufacturerSource.Name,
		Material.BatchingOrder,
		ItemName.Name,
		ItemDescription.[Description],
		ItemCategory.ItemCategory,
		ItemCategory.[Description],
		ItemCategory.ShortDescription,
		BatchPanelName.Name
From CANEST_Quadrel_Test_RJ.dbo.Plants As Plants
Inner Join CANEST_Quadrel_Test_RJ.dbo.MATERIAL As Material
On Material.PlantID = Plants.PlantId
Inner Join CANEST_Quadrel_Test_RJ.dbo.Name As TradeName
On TradeName.NameID = Material.NameID
Left Join CANEST_Quadrel_Test_RJ.dbo.[Description] As Description
On Description.DescriptionID = Material.DescriptionID
Left Join CANEST_Quadrel_Test_RJ.dbo.Manufacturer As Manufacturer
On Manufacturer.ManufacturerID = Material.ManufacturerID
Left Join CANEST_Quadrel_Test_RJ.dbo.ManufacturerSource As ManufacturerSource
On ManufacturerSource.ManufacturerSourceID = Material.ManufacturerSourceID  
Left Join iServiceDataExchange.dbo.MaterialType As FamilyMaterialType
On Material.FamilyMaterialTypeID = FamilyMaterialType.MaterialTypeID
Left Join iServiceDataExchange.dbo.MaterialType As MaterialType
On Material.MaterialTypeLink = MaterialType.MaterialTypeID
Left Join CANEST_Quadrel_Test_RJ.dbo.ItemMaster As ItemMaster
On ItemMaster.ItemMasterID = Material.ItemMasterID
Left Join CANEST_Quadrel_Test_RJ.dbo.Name As ItemName
On ItemName.NameID = ItemMaster.NameID
Left Join CANEST_Quadrel_Test_RJ.dbo.[Description] As ItemDescription
On ItemDescription.DescriptionID = ItemMaster.DescriptionID
Left Join CANEST_Quadrel_Test_RJ.dbo.ProductionItemCategory As ItemCategory
On ItemCategory.ProdItemCatID = ItemMaster.ProdItemCatID
Left Join CANEST_Quadrel_Test_RJ.dbo.ProductionItemCategory As ComponentCategory
On ComponentCategory.ProdItemCatID = ItemMaster.ProdItemCompTypeID
Left Join CANEST_Quadrel_Test_RJ.dbo.Name As BatchPanelName
On BatchPanelName.NameID = Material.BatchPanelNameID
Left Join CANEST_Quadrel_Test_RJ.dbo.GetMaterialConvertedCostsByUnitSys(Null, CANEST_Quadrel_Test_RJ.dbo.GetMaterialCostsAreRetrievedFromHistory(), Null, Null, CANEST_Quadrel_Test_RJ.dbo.GetDBSetting_MaterialHistoryCostsDefaultHistoryPeriod(Default), Null, 2) As CostInfo
On Material.MATERIALIDENTIFIER = CostInfo.MaterialID
Where	ItemName.Name In
		(
			'4354',
			'4992',
			'5645'			
		)
Order By ItemName.Name, Plants.Name, TradeName.Name

Select MixInfo.PlantCode, MixInfo.MaterialItemCode, MixInfo.MaterialItemDescription
From Data_Import_RJ.dbo.TestImport0000_XML_MixInfo As MixInfo
Left Join
(
	Select -1 As ID, Plants.Name As PlantCode, ItemName.Name As ItemCode
	From CANEST_Quadrel_Test_RJ.dbo.Plants As Plants
	Inner Join CANEST_Quadrel_Test_RJ.dbo.MATERIAL As Material
	On Material.PlantID = Plants.PlantId
	Inner Join CANEST_Quadrel_Test_RJ.dbo.ItemMaster As ItemMaster
	On ItemMaster.ItemMasterID = Material.ItemMasterID
	Inner Join CANEST_Quadrel_Test_RJ.dbo.Name As ItemName
	On ItemName.NameID = ItemMaster.NameID	
) As ExistingMtrl
On	MixInfo.PlantCode = ExistingMtrl.PlantCode And
	MixInfo.MaterialItemCode = ExistingMtrl.ItemCode
Where ExistingMtrl.ID Is Null
Group By MixInfo.PlantCode, MixInfo.MaterialItemCode, MixInfo.MaterialItemDescription
Order By MixInfo.PlantCode, MixInfo.MaterialItemCode, MixInfo.MaterialItemDescription

Select MixInfo.PlantCode, MixInfo.MaterialItemCode, MixInfo.MaterialItemDescription
From Data_Import_RJ.dbo.TestImport0000_XML_MixInfo As MixInfo
Left Join
(
	Select -1 As ID, ItemName.Name As ItemCode
	From CANEST_Quadrel_Prod_RJ.dbo.Plants As Plants
	Inner Join CANEST_Quadrel_Prod_RJ.dbo.MATERIAL As Material
	On Material.PlantID = Plants.PlantId
	Inner Join CANEST_Quadrel_Prod_RJ.dbo.ItemMaster As ItemMaster
	On ItemMaster.ItemMasterID = Material.ItemMasterID
	Inner Join CANEST_Quadrel_Prod_RJ.dbo.Name As ItemName
	On ItemName.NameID = ItemMaster.NameID
	Group By ItemName.Name	
) As ExistingMtrl
On	MixInfo.MaterialItemCode = ExistingMtrl.ItemCode
Where ExistingMtrl.ID Is Null
Group By MixInfo.PlantCode, MixInfo.MaterialItemCode, MixInfo.MaterialItemDescription
Order By MixInfo.PlantCode, MixInfo.MaterialItemCode, MixInfo.MaterialItemDescription

