Declare @MaterialDate Nvarchar (40) = '10/01/2023'

Insert into Data_Import_RJ.dbo.TestImport0000_MaterialInfo 
(
	PlantName, TradeName, MaterialDate, FamilyMaterialTypeName, MaterialTypeName,
	SpecificGravity, IsLiquidAdmix, MoisturePct, Cost, CostUnitName,
	ManufacturerName, ManufacturerSourceName, BatchingOrderNumber, ItemCode,
	ItemDescription, ItemShortDescription, ItemCategoryName,
	ItemCategoryDescription, ItemCategoryShortDescription, ComponentCategoryName,
	ComponentCategoryDescription, ComponentCategoryShortDescription,
	BatchPanelCode, UpdatedFromDatabase
)
Select  MaterialInfo.PlantCode, 
        Case when Isnull(MaterialInfo.[Description], '') <> '' Then MaterialInfo.[Description] Else MaterialInfo.ItemCode End As TradeName,
        Isnull(DBMaterialInfo.MaterialDate, '06/06/2023') As MaterialDate,
        Isnull(DBMaterialInfo.FamilyMaterialTypeName, DBMaterialInfo2.FamilyMaterialTypeName) As FamilyMaterialTypeName,
        Isnull(DBMaterialInfo.MaterialTypeName, DBMaterialInfo2.MaterialTypeName) As MaterialTypeName,
        Case when Isnull(MaterialInfo.SpecificGravity, -1.0) >= 0.3 Then MaterialInfo.SpecificGravity Else Isnull(DBMaterialInfo.SpecificGravity, DBMaterialInfo2.SpecificGravity) End As SpecificGravity,
        Isnull(DBMaterialInfo.IsLiquidAdmix, DBMaterialInfo2.IsLiquidAdmix) As IsLiquidAdmix,
        Isnull(MaterialInfo.MoisturePercent, 0.0) As MoisturePercent,
        MaterialInfo.Cost,
        MaterialInfo.PurchaseUnit,
        Null As ManufacturerName,
        Null As ManufacturerSourceName,
        Null As BatchingOrderNumber,
        MaterialInfo.ItemCode,
        MaterialInfo.[Description],
        MaterialInfo.ShortDescription,
        ItemCategory.Code,
        ItemCategory.[Description],
        ItemCategory.ShortDescription,
        Null As ComponentCategoryName,
        Null As ComponentCategoryDescription,
        Null As ComponentCategoryShortDescription,
        Null As BatchPanelCode,
        Case when DBMaterialInfo.AutoID Is Not null Or DBMaterialInfo2.AutoID Is Not Null Then 1 Else 0 End As UpdatedFromDatabase
From Data_Import_RJ.dbo.TestImport0000_XML_Material As MaterialInfo

Left Join
(
    Select	-1 As AutoID,
            IsNull(Plants.Name, '') As PlantCode,
		    IsNull(TradeName.Name, '') As TradeName,
		    Material.DATE As MaterialDate,
		    IsNull(FamilyMaterialType.MaterialType, '') As FamilyMaterialTypeName,
		    IsNull(MaterialType.MaterialType, '') As MaterialTypeName,
		    Round(Material.SPECGR, 4) As SpecificGravity,
            Case
                When Isnull(Material.FamilyMaterialTypeID, -1) = 3 And Isnull(Material.MOISTURE, -1.0) > 0.0
                Then 'Yes'
                Else 'No'
            End As IsLiquidAdmix,
            Round(Material.MOISTURE * 100.0, 2) As MoisturePercent,
            Round(CostInfo.ConvertedCost, 2) As Cost,
            IsNull(CostInfo.ConvertedCostUnits, '') As CostUnitName,
            IsNull(Manufacturer.Name, '') As ManufacturerName,
            IsNull(ManufacturerSource.Name, '') As ManufacturerSourceName,
            IsNull(Material.BatchingOrder, '') As BatchingOrderNumber,
            IsNull(ItemName.Name, '') As ItemCode,
            Case 
                When Isnull(ItemDescription.[Description], '') <> '' 
                Then ItemDescription.[Description]
                When Isnull(Description.[Description], '') <> ''
                Then Description.[Description] 
                Else ''
            End As ItemDescription,
            Isnull(ItemMaster.ItemShortDescription, '') As ItemShortDescription,
            IsNull(ItemCategory.ItemCategory, '') As ItemCategoryName, 
            IsNull(ItemCategory.[Description], '') As ItemCategoryDescription,
            IsNull(ItemCategory.ShortDescription, '') As ItemCategoryShortDescription,
            IsNull(BatchPanelName.Name, '') As BatchPanelCode
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
    Left Join dbo.GetMaterialConvertedCostsByUnitSys(Null, dbo.GetMaterialCostsAreRetrievedFromHistory(), Null, Null, dbo.GetDBSetting_MaterialHistoryCostsDefaultHistoryPeriod(Default), Null, 1) As CostInfo
    On Material.MATERIALIDENTIFIER = CostInfo.MaterialID
    Where   Material.MATERIALIDENTIFIER In
            (
            	Select Min(Material.MATERIALIDENTIFIER)
            	From dbo.MATERIAL As Material
            	Where Material.ItemMasterID Is Not null
            	Group By Material.PlantID, Material.ItemMasterID
            )
) As DBMaterialInfo
On MaterialInfo.PlantCode = DBMaterialInfo.PlantCode And MaterialInfo.ItemCode = DBMaterialInfo.ItemCode
Left Join
(
    Select	-1 As AutoID,
            IsNull(Plants.Name, '') As PlantCode,
		    IsNull(TradeName.Name, '') As TradeName,
		    Material.DATE As MaterialDate,
		    IsNull(FamilyMaterialType.MaterialType, '') As FamilyMaterialTypeName,
		    IsNull(MaterialType.MaterialType, '') As MaterialTypeName,
		    Round(Material.SPECGR, 4) As SpecificGravity,
            Case
                When Isnull(Material.FamilyMaterialTypeID, -1) = 3 And Isnull(Material.MOISTURE, -1.0) > 0.0
                Then 'Yes'
                Else 'No'
            End As IsLiquidAdmix,
            Round(Material.MOISTURE * 100.0, 2) As MoisturePercent,
            Round(CostInfo.ConvertedCost, 2) As Cost,
            IsNull(CostInfo.ConvertedCostUnits, '') As CostUnitName,
            IsNull(Manufacturer.Name, '') As ManufacturerName,
            IsNull(ManufacturerSource.Name, '') As ManufacturerSourceName,
            IsNull(Material.BatchingOrder, '') As BatchingOrderNumber,
            IsNull(ItemName.Name, '') As ItemCode,
            Case 
                When Isnull(ItemDescription.[Description], '') <> '' 
                Then ItemDescription.[Description]
                When Isnull(Description.[Description], '') <> ''
                Then Description.[Description] 
                Else ''
            End As ItemDescription,
            Isnull(ItemMaster.ItemShortDescription, '') As ItemShortDescription,
            IsNull(ItemCategory.ItemCategory, '') As ItemCategoryName, 
            IsNull(ItemCategory.[Description], '') As ItemCategoryDescription,
            IsNull(ItemCategory.ShortDescription, '') As ItemCategoryShortDescription,
            IsNull(BatchPanelName.Name, '') As BatchPanelCode
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
    Left Join dbo.GetMaterialConvertedCostsByUnitSys(Null, dbo.GetMaterialCostsAreRetrievedFromHistory(), Null, Null, dbo.GetDBSetting_MaterialHistoryCostsDefaultHistoryPeriod(Default), Null, 1) As CostInfo
    On Material.MATERIALIDENTIFIER = CostInfo.MaterialID
    Where   Material.MATERIALIDENTIFIER In
            (
            	Select Max(Material.MATERIALIDENTIFIER)
            	From dbo.MATERIAL As Material
            	Where Material.ItemMasterID Is Not null
            	Group By Material.ItemMasterID
            )
) As DBMaterialInfo2
On MaterialInfo.ItemCode = DBMaterialInfo2.ItemCode
Left Join Data_Import_RJ.dbo.TestImport0000_XML_ItemCategory As ItemCategory
On MaterialInfo.ItemCategoryCode = ItemCategory.Code
Left Join Data_Import_RJ.dbo.TestImport0000_XML_MaterialInfo As ExistingMaterial
On  MaterialInfo.PlantCode = ExistingMaterial.PlantName And
    MaterialInfo.ItemCode = ExistingMaterial.ItemCode
Where   ExistingMaterial.AutoID Is Null And
        Isnull(MaterialInfo.Cost, -1.0) >= 0.0 And
        MaterialInfo.ItemCode In
        (
        	Select MixInfo.MaterialItemCode
        	From Data_Import_RJ.dbo.TestImport0000_XML_Mix As MixInfo
        	Group By MixInfo.MaterialItemCode
        	
        	Union All
        	
        	Select ItemName.Name
        	From dbo.MATERIAL As Material
            Inner Join dbo.ItemMaster As ItemMaster
            On ItemMaster.ItemMasterID = Material.ItemMasterID
            Inner Join dbo.Name As ItemName
            On ItemName.NameID = ItemMaster.NameID
        	Group By ItemName.Name
        )
Order By MaterialInfo.ItemCode, MaterialInfo.PlantCode


Insert into Data_Import_RJ.dbo.TestImport0000_XML_MixInfo 
(
	PlantCode, MixCode, MixDescription, MixShortDescription, ItemCategory,
	StrengthAge, Strength, AirContent, MinAirContent, MaxAirContent, Slump,
	MinSlump, MaxSlump, AggregateSize, MaxLoadSize, MaximumWater, SackContent,
	MaxWCRatio, MaterialItemCode, MaterialItemDescription, Quantity,
	QuantityUnitName, DosageQuantity, SortNumber
)
Select  MixData.PlantCode,
        MixData.ItemCode,
        MixData.[Description],
        MixData.ShortDescription,
        MixData.ItemCategoryCode,
        Case
            When Isnull(MixData.Strength, -1.0) <= 0.1
            Then Null
            When Isnull(MixData.StrengthAge, -1.0) <= 0.01 Or Isnull(MixData.StrengthAge, -1.0) >= 100.0
            Then 28.0
            Else MixData.StrengthAge
        End As StrengthAge,
        Case
            When Isnull(MixData.Strength, -1.0) <= 0.1
            Then Null
            Else MixData.Strength
        End As Strength,
        Case 
            When Isnull(MixData.PercentAirVolume, -1.0) < 0.0 Or Isnull(MixData.PercentAirVolume, -1.0) > 90.0
            Then Null
            Else MixData.PercentAirVolume
        End As AirContent,
        Case 
            When Isnull(MixData.PercentAirVolume, -1.0) < 0.0 Or Isnull(MixData.PercentAirVolume, -1.0) > 90.0
            Then Null
            When MixData.PercentAirVolume < 1.51
            Then 0.0
            Else MixData.PercentAirVolume - 1.50
        End As MinAirContent,
        Case 
            When Isnull(MixData.PercentAirVolume, -1.0) < 0.0 Or Isnull(MixData.PercentAirVolume, -1.0) > 90.0
            Then Null
            Else MixData.PercentAirVolume + 1.50
        End As MaxAirContent,
        Case
            When dbo.Validation_ValueIsNumeric(MixData.Slump) = 0
            Then Null
            When Isnull(Cast(MixData.Slump As Float), -1.0) <= 0.1
            Then Null
            Else Cast(MixData.Slump As Float)
        End As Slump,
        Case
            When dbo.Validation_ValueIsNumeric(MixData.Slump) = 0
            Then Null
            When Isnull(Cast(MixData.Slump As Float), -1.0) <= 0.1
            Then Null
            When Cast(MixData.Slump As Float) <= 1.1
            Then 0.0
            Else Cast(MixData.Slump As Float) - 1.0
        End As MinSlump,
        Case
            When dbo.Validation_ValueIsNumeric(MixData.Slump) = 0
            Then Null
            When Isnull(Cast(MixData.Slump As Float), -1.0) <= 0.1
            Then Null
            When Cast(MixData.Slump As Float) >= 10.9 And Cast(MixData.Slump As Float) <= 12.0
            Then 12.0
            Else Cast(MixData.Slump As Float) + 1.0
        End As MaxSlump,
        Null As AggregateSize,
        Case
            When Isnull(MixData.MaximumBatchSize, -1.0) <= 0.1
            Then Null
            Else MixData.MaximumBatchSize
        End As MaximumBatchSize,
        Case
            When Isnull(MixData.MaximumWater, -1.0) <= 0.1
            Then Null
            Else MixData.MaximumWater
        End As MaximumWater,
        Null As SackContent,
        Case
            When Isnull(MixData.WaterCementRatio, -1.0) <= 0.0
            Then Null
            Else MixData.WaterCementRatio
        End As WaterCementRatio,
        MixData.MaterialItemCode,
        MixData.MaterialItemDescription,
        Case
            When Isnull(MixData.Quantity, -1.0) < 0.0
            Then 0.0
            Else MixData.Quantity
        End As Quantity,
        MixData.QuantityUnitName,
        MixData.DosageQuantity,
        MixData.MaterialSortNumber
From Data_Import_RJ.dbo.TestImport0000_XML_Mix As MixData
Left Join Data_Import_RJ.dbo.TestImport0000_MixInfo As ExistingMix
On  MixData.PlantCode = ExistingMix.PlantCode And
    MixData.ItemCode = ExistingMix.MixCode And
    MixData.MaterialItemCode = ExistingMix.MaterialItemCode
Where ExistingMix.AutoID Is Null
Order By MixData.PlantCode, MixData.ItemCode, MixData.MaterialSortNumber, MixData.MaterialItemCode


Delete MixInfo
From Data_Import_RJ.dbo.TestImport0000_MixInfo As MixInfo
Inner Join
(
	Select MixInfo2.PlantCode, MixInfo2.MixCode, MixInfo2.MaterialItemCode, Min(MixInfo2.AutoID) As AutoID
	From Data_Import_RJ.dbo.TestImport0000_MixInfo As MixInfo2
	Where MixInfo2.Quantity = 0.0
	Group By MixInfo2.PlantCode, MixInfo2.MixCode, MixInfo2.MaterialItemCode
	Having Count(*) > 1
) As MixInfo3
On  MixInfo.PlantCode = MixInfo3.PlantCode And
    MixInfo.MixCode = MixInfo3.MixCode And
    MixInfo.MaterialItemCode = MixInfo3.MaterialItemCode
Where MixInfo.Quantity = 0.0 And MixInfo.AutoID <> MixInfo3.AutoID
