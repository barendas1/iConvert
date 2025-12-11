Select	
		IsNull(FamilyMaterialType.MaterialType, '') As [Family Material Type],
        IsNull(Plants.Name, '') As [Plant Code],
		IsNull(TradeName.Name, '') As [Trade Name],
        IsNull(ItemName.Name, '') As [Item Code],
        Case 
            When Isnull(ItemDescription.[Description], '') <> '' 
            Then ItemDescription.[Description]
            When Isnull(Description.[Description], '') <> ''
            Then Description.[Description] 
            Else ''
        End As [Item Description],
        Round(CostInfo.ConvertedCost, 2) As [Cost],
        IsNull(CostInfo.ConvertedCostUnits, '') As [Cost Unit Name],
        Round(MaterialInfo.Cost, 2) As [O&G Cost],
        MaterialInfo.PurchaseUnit As [O&G Purchase Unit Name],
        MaterialInfo.PriceQuantityUnit As [O&G Price Quantity Unit Name],
		IsNull(MaterialType.MaterialType, '') As [Material Type],
        IsNull(ItemCategory.ItemCategory, '') As [Item Category], 
        IsNull(ItemCategory.[Description], '') As [Item Category Description],
		Material.DATE As [Material Date],
		Round(Material.SPECGR, 4) As [Specific Gravity],
        IsNull(Manufacturer.Name, '') As [Manufacturer],
        IsNull(ManufacturerSource.Name, '') As [Manufacturer Source]
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
Inner Join Data_Import_RJ.dbo.TestImport0000_XML_Material As MaterialInfo
On  Plants.Name = Right('00' + MaterialInfo.PlantCode, 2) And
    ItemName.Name = MaterialInfo.ItemCode
--Where Isnull(MaterialInfo.Cost, -1.0) >= 0.0 And Round(Isnull(CostInfo.ConvertedCost, -1.0), 2) = Round(Isnull(MaterialInfo.Cost, -1.0), 2)
Order By ItemName.Name, Plants.Name


