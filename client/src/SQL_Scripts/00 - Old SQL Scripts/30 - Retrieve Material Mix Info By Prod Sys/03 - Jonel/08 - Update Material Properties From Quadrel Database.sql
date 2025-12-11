If  Exists (Select * From Sys.databases Where Name = 'Data_Import_RJ') And
    Exists (Select * From sys.objects Where Name = 'ACIBatchViewDetails')
Begin
    If Exists (Select * From Data_Import_RJ.sys.objects Where Name = 'TestImport0000_MaterialInfo')
    Begin
    	Update MaterialInfo
    	    Set --MaterialInfo.TradeName = ExistingMaterial.[Trade Name],
                MaterialInfo.MaterialDate = ExistingMaterial.[Material Date],
                MaterialInfo.FamilyMaterialTypeName = ExistingMaterial.[Family Material Type],
                MaterialInfo.MaterialTypeName = ExistingMaterial.[Material Type],
                MaterialInfo.SpecificGravity = Case when Isnull(MaterialInfo.SpecificGravity, -1.0) <= 0.3 Then ExistingMaterial.[Specific Gravity] Else MaterialInfo.SpecificGravity End,
                MaterialInfo.IsLiquidAdmix = ExistingMaterial.[Is Liquid Admixture],
                MaterialInfo.MoisturePct = ExistingMaterial.[Water Contribution (%)],
                MaterialInfo.Cost = Case when Isnull(MaterialInfo.Cost, -1.0) > 0.0 Then MaterialInfo.Cost Else ExistingMaterial.Cost End,
                MaterialInfo.CostUnitName = Case when Isnull(MaterialInfo.Cost, -1.0) > 0.0 Then MaterialInfo.CostUnitName Else ExistingMaterial.[Cost Unit Name] End,
                --MaterialInfo.ManufacturerName = ExistingMaterial.Manufacturer,
                --MaterialInfo.ManufacturerSourceName = ExistingMaterial.[Manufacturer Source],
                MaterialInfo.BatchingOrderNumber = ExistingMaterial.[Batching Order Number],
                /*
                MaterialInfo.ItemDescription = ExistingMaterial.[Item Description],
                MaterialInfo.ItemShortDescription = ,
                MaterialInfo.ItemCategoryName = ,
                MaterialInfo.ItemCategoryDescription = ,
                MaterialInfo.ItemCategoryShortDescription = ,
                MaterialInfo.ComponentCategoryName = ,
                MaterialInfo.ComponentCategoryDescription = ,
                MaterialInfo.ComponentCategoryShortDescription = ,
                */
                MaterialInfo.BatchPanelCode = Case when Isnull(MaterialInfo.BatchPanelCode, '') <> '' Then MaterialInfo.BatchPanelCode Else ExistingMaterial.[Batch Panel Code] End,
                MaterialInfo.UpdatedFromDatabase = 1
    	From Data_Import_RJ.dbo.TestImport0000_MaterialInfo As MaterialInfo
    	Inner Join
    	(
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
            --Where Plants.Name Not In ('Concrete Plant', 'Product Plant', 'QLab Plant')
            --Order By Plants.Name, FamilyMaterialType.MaterialType, ItemName.Name, TradeName.Name
    	) As ExistingMaterial
    	On  MaterialInfo.PlantName = ExistingMaterial.[Plant Code] And
    	    MaterialInfo.ItemCode = ExistingMaterial.[Item Code]
    End
End
Go
