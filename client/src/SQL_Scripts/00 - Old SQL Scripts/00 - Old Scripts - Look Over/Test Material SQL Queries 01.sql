Select	IsNull(Plants.Name, '') As [Plant Code],
		IsNull(TradeName.Name, '') As [Trade Name],
		Material.DATE As [Material Date],
		IsNull(FamilyMaterialType.MaterialType, '') As [Family Material Type],
		IsNull(MaterialType.MaterialType, '') As [Material Type],
		Round(Material.SPECGR, 4) As [Specific Gravity],
        Case
            When Isnull(Material.FamilyMaterialTypeID, -1) = 3 And Isnull(Material.MOISTURE, -1.0) > 0.0
            Then 'Yes'
            Else 'No'
        End As [Is Liquid Admixture],
        Round(Material.MOISTURE * 100.0, 2) As [Water Contribution (%)],
        Round(CostInfo.ConvertedCost, 2) As [Cost],
        IsNull(CostInfo.ConvertedCostUnits, '') As [Cost Unit Name],
        IsNull(Manufacturer.Name, '') As [Manufacturer],
        IsNull(ManufacturerSource.Name, '') As [Manufacturer Source],
        IsNull(Material.BatchingOrder, '') As [Batching Order Number],
        IsNull(ItemName.Name, '') As [Item Code],
        Case 
            When Isnull(ItemDescription.[Description], '') <> '' 
            Then ItemDescription.[Description]
            When Isnull(Description.[Description], '') <> ''
            Then Description.[Description] 
            Else ''
        End As [Item Description],
        Isnull(ItemMaster.ItemShortDescription, '') As [Item Short Description],
        IsNull(ItemCategory.ItemCategory, '') As [Item Category], 
        IsNull(ItemCategory.[Description], '') As [Item Category Description],
        IsNull(ItemCategory.ShortDescription, '') As [Item Category Short Description],
        IsNull(BatchPanelName.Name, '') As [Batch Panel Code]
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
Inner Join dbo.ItemMaster As ItemMaster
On ItemMaster.ItemMasterID = Material.ItemMasterID
Inner Join dbo.Name As ItemName
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
Where MaterialType.MaterialType In ('1 "', '# 5', '# 56', '# 57') --ItemName.Name In ('11STONE', '23SAND', '5STONE', '9STONE')
Order By ItemName.Name, Plants.Name, FamilyMaterialType.MaterialType, TradeName.Name

Select *
From dbo.Static_MaterialType As MaterialType
Order By MaterialType.RecipeOrder

Select  MaterialInfo.PlantName As [Plant Name],
        MaterialInfo.TradeName As [Trade Name],
        MaterialInfo.MaterialDate As [Material Date],
        MaterialInfo.FamilyMaterialTypeName As [Family Material Type],
        MaterialInfo.MaterialTypeName As [Material Type],
        MaterialInfo.SpecificGravity As [Specific Gravity],
        MaterialInfo.IsLiquidAdmix As [Is Liquid Admix],
        MaterialInfo.MoisturePct As [Moisture (%)],
        MaterialInfo.Cost As Cost,
        MaterialInfo.CostUnitName As [Cost Unit Name],
        MaterialInfo.ManufacturerName As [Manufacturer],
        MaterialInfo.ManufacturerSourceName As [Manufacturer Source],
        MaterialInfo.BatchingOrderNumber As [Batching Order Number],
        MaterialInfo.ItemCode As [Item Code],
        MaterialInfo.ItemDescription As [Item Description],
        MaterialInfo.ItemShortDescription As [Item Short Description],
        MaterialInfo.ItemCategoryName As [Item Category],
        MaterialInfo.ItemCategoryDescription As [Item Category Description],
        MaterialInfo.ItemCategoryShortDescription As [Item Category Short Description],
        MaterialInfo.BatchPanelCode As [Batch Panel Code]
From Data_Import_RJ.dbo.TestImport0000_MaterialInfo As MaterialInfo
Order By MaterialInfo.AutoID
