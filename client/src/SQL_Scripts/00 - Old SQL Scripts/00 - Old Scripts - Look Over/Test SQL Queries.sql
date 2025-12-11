/*
Select 'Item Category' As [Type], * 
From dbo.TestImport0000_ItemCategory As Info
Order By Info.AutoID

Select 'Item Type' As [Type], * 
From dbo.TestImport0000_ItemType As Info
Order By Info.AutoID

Select 'Location' As [Type], * 
From dbo.TestImport0000_Location As Info
Order By Info.AutoID

Select 'Material' As [Type], * 
From dbo.TestImport0000_Material As Info
Order By Info.AutoID

Select 'Mix' As [Type], * 
From dbo.TestImport0000_Mix As Info
Order By Info.AutoID

Select 'Plant' As [Type], * 
From dbo.TestImport0000_Plant As Info
Order By Info.AutoID

Select MixInfo.PlantCode, MixInfo.ItemCode, MixInfo.[Description], MixInfo.ShortDescription, MixProp.MixDescription
From Data_Import_RJ.dbo.TestImport0000_Mix As MixInfo
Inner Join Data_Import_RJ.dbo.TestImport0000_MixProps As MixProp
On MixProp.PlantCode = MixInfo.PlantCode And MixProp.MixCode = MixInfo.ItemCode
Where Isnull(MixProp.ItemCategoryCode, '') <> Isnull(MixInfo.ItemCategoryCode, '')

Select *
From Data_Import_RJ.dbo.TestImport0000_Mix As MixInfo
Where dbo.Validation_ValueIsNumeric(MixInfo.Slump) = 0

Select *
From OGIndustries_RJ.dbo.Static_MaterialType As Info
Order By Info.RecipeOrder

Select *
From Data_Import_RJ.dbo.TestImport0000_Mix As MixInfo
Where MixInfo.Strength Is Not Null

Select *
From Data_Import_RJ.dbo.TestImport0000_Plant As PlantInfo
Order By PlantInfo.AutoID

Select *
From Data_Import_RJ.dbo.TestImport0000_ItemCategory As Info
Order By Info.Code

Select  Material.PlantCode,
        LocationInfo.Name,
        Material.ItemCode,
        Material.[Description],
        Material.ShortDescription,
        Material.ItemCategoryCode,
        ItemCategory.[Description],
        Material.ItemTypeName,
        Material.SpecificGravity,
        Material.MoisturePercent,
        Material.Cost,
        Material.Price,
        Material.PurchaseUnit,
        Material.PriceQuantityUnit,
        Material.OrderedQuantityUnit,
        Material.DeliveredQuantityUnit,
        Material.BatchUnit,
        Material.InventoryUnit,
        Material.ReportingUnit,
        Material.CostExtensionCode,
        Material.PriceCategoryCode,
        Material.PriceCategoryName,
        Material.PriceExtensionCode
From Data_Import_RJ.dbo.TestImport0000_Material As Material
Left Join Data_Import_RJ.dbo.TestImport0000_Location As LocationInfo
On Material.PlantCode = LocationInfo.Code
Left Join Data_Import_RJ.dbo.TestImport0000_ItemCategory As ItemCategory
On  Material.ItemCategoryCode = ItemCategory.Code     
Order By Material.ItemCode, Material.PlantCode
*/

Select  Material.PlantCode As [Plant Code],
        LocationInfo.Name As [Plant Description],
        Material.ItemCode As [Item Code],
        Material.[Description] As [Description],
        Material.ShortDescription As [Short Description],
        Material.Cost As [Cost],
        Material.Price As [Price],
        Material.PurchaseUnit As [Purchase Unit Name],
        Material.PriceQuantityUnit As [Price Quantity Unit Name],
        Material.ItemCategoryCode As [Item Category Name],
        ItemCategory.[Description] As [Item Category Description],
        Material.ItemTypeName As [Item Type Name],
        Material.SpecificGravity As [Specific Gravity],
        Material.MoisturePercent As [Moisture (%)],
        Material.OrderedQuantityUnit As [Ordered Quantity Unit Name],
        Material.DeliveredQuantityUnit As [Delivered Quantity Unit Name],
        Material.BatchUnit As [Batch Unit Name],
        Material.InventoryUnit As [Inventory Unit Name],
        Material.ReportingUnit As [Reporting Unit Name],
        Material.CostExtensionCode As [Cost Extension Code],
        Material.PriceCategoryCode As [Price Category Code],
        Material.PriceCategoryName As [Price Category Name],
        Material.PriceExtensionCode As [Prime Extension Code]
From Data_Import_RJ.dbo.TestImport0000_Material As Material
Left Join Data_Import_RJ.dbo.TestImport0000_Location As LocationInfo
On Material.PlantCode = LocationInfo.Code
Left Join Data_Import_RJ.dbo.TestImport0000_ItemCategory As ItemCategory
On  Material.ItemCategoryCode = ItemCategory.Code     
Order By Material.ItemCode, Right('00' + Material.PlantCode, 2)




Select  Material.PlantCode As [Plant Code],
        LocationInfo.Name As [Plant Description],
        Material.ItemCode As [Item Code],
        Material.[Description] As [Description],
        Material.ShortDescription As [Short Description],
        Material.Cost As [Cost],
        Material.Price As [Price],
        Material.PurchaseUnit As [Purchase Unit Name],
        Material.PriceQuantityUnit As [Price Quantity Unit Name],
        MaterialInfo.Cost As [Cost In Quadrel],
        MaterialInfo.CostUnitName As [Cost Unit Name In Quadrel],
        Material.ItemCategoryCode As [Item Category Name],
        ItemCategory.[Description] As [Item Category Description],
        Material.ItemTypeName As [Item Type Name],
        Material.SpecificGravity As [Specific Gravity],
        Material.MoisturePercent As [Moisture (%)],
        Material.OrderedQuantityUnit As [Ordered Quantity Unit Name],
        Material.DeliveredQuantityUnit As [Delivered Quantity Unit Name],
        Material.BatchUnit As [Batch Unit Name],
        Material.InventoryUnit As [Inventory Unit Name],
        Material.ReportingUnit As [Reporting Unit Name],
        Material.CostExtensionCode As [Cost Extension Code],
        Material.PriceCategoryCode As [Price Category Code],
        Material.PriceCategoryName As [Price Category Name],
        Material.PriceExtensionCode As [Prime Extension Code]
From Data_Import_RJ.dbo.TestImport0000_Material As Material
Left Join Data_Import_RJ.dbo.TestImport0000_Location As LocationInfo
On Material.PlantCode = LocationInfo.Code
Left Join Data_Import_RJ.dbo.TestImport0000_ItemCategory As ItemCategory
On  Material.ItemCategoryCode = ItemCategory.Code
Inner Join
(
    Select	IsNull(Plants.Name, '') As PlantCode,
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
            Round(Material.MOISTURE * 100.0, 2) As MoisturePct,
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
) As MaterialInfo
On  Right('00' + Material.PlantCode, 2) = MaterialInfo.PlantCode And
    Material.ItemCode = MaterialInfo.ItemCode
Order By Material.ItemCode, Right('00' + Material.PlantCode, 2)


Select  MaterialInfo.PlantID As [Location ID],
        MaterialInfo.PlantCode As [Location Code],
        MaterialInfo.ItemCode As [Item Code],
        MaterialInfo.Description As [Description],
        MaterialInfo.SpecificGravity As [Specific Gravity],
        MaterialInfo.Cost As [Cost],
        MaterialInfo.PurchaseUnit As [Cost Unit Name],
        MaterialInfo.ItemCategoryCode As [Item Category],
        MaterialInfo.ItemTypeName As [Item Type]
From Data_Import_RJ.dbo.TestImport0000_Material As MaterialInfo
Order By MaterialInfo.PlantCode, MaterialInfo.ItemCode

Select  MaterialInfo.PlantID As [Location ID],
        MaterialInfo.PlantCode As [Location Code],
        MaterialInfo.ItemCode As [Item Code],
        MaterialInfo.Description As [Description],
        MaterialInfo.SpecificGravity As [Specific Gravity],
        MaterialInfo.Cost As [Cost],
        MaterialInfo.PurchaseUnit As [Cost Unit Name],
        MaterialInfo.ItemCategoryCode As [Item Category],
        MaterialInfo.ItemTypeName As [Item Type]
From Data_Import_RJ.dbo.Import0064_Material As MaterialInfo
Order By MaterialInfo.PlantCode, MaterialInfo.ItemCode
