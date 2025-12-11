Declare @UseItemCodeAsBatchPanelCode Bit = 1

If Exists (Select * From Sys.databases Where Name = 'Data_Import_RJ')
Begin
    If Exists (Select * From Data_Import_RJ.sys.objects Where Name = 'TestImport0000_MixInfo')
    Begin    	
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
        Select  MixInfo.PlantCode, 
                Case 
                    When Isnull(DBMaterialInfo.TradeName, '') <> '' 
                    Then DBMaterialInfo.TradeName 
                    When Isnull(MixInfo.MaterialItemDescription, '') <> '' 
                    Then MixInfo.MaterialItemDescription
                    Else MixInfo.MaterialItemCode
                End As TradeName,
                '08/29/2023' As MaterialDate,
                DBMaterialInfo.FamilyMaterialTypeName As FamilyMaterialTypeName,
                DBMaterialInfo.MaterialTypeName As MaterialTypeName,
                DBMaterialInfo.SpecificGravity As SpecificGravity,
                DBMaterialInfo.IsLiquidAdmix As IsLiquidAdmix,
                DBMaterialInfo.MoisturePercent As MoisturePercent,
                Null As Cost,
                Null As CostUnitName,
                Null As ManufacturerName,
                Null As ManufacturerSourceName,
                DBMaterialInfo.BatchingOrderNumber As BatchingOrderNumber,
                MixInfo.MaterialItemCode,
                Case 
                    When Isnull(DBMaterialInfo.ItemDescription, '') <> '' 
                    Then DBMaterialInfo.ItemDescription 
                    Else MixInfo.MaterialItemDescription 
                End As MaterialDescription,
                Case 
                    When Isnull(DBMaterialInfo.ItemShortDescription, '') <> ''
                    Then DBMaterialInfo.ItemShortDescription
                    When Isnull(DBMaterialInfo.ItemDescription, '') <> '' 
                    Then DBMaterialInfo.ItemDescription 
                    Else MixInfo.MaterialItemDescription 
                End As MaterialShortDescription,
                Null As ItemCategoryName,
                Null As ItemCategoryDescription,
                Null As ItemCategoryShortDescription,
                Null As ComponentCategoryName,
                Null As ComponentCategoryDescription,
                Null As ComponentCategoryShortDescription,

                /*
                DBMaterialInfo.ItemCategoryName,
                DBMaterialInfo.ItemCategoryDescription,
                DBMaterialInfo.ItemCategoryShortDescription,
                DBMaterialInfo.ComponentCategoryName As ComponentCategoryName,
                DBMaterialInfo.ComponentCategoryDescription As ComponentCategoryDescription,
                DBMaterialInfo.ComponentCategoryShortDescription As ComponentCategoryShortDescription,
                */

                Case when Isnull(@UseItemCodeAsBatchPanelCode, 0) = 1 Then MixInfo.MaterialItemCode Else Null End As BatchPanelCode,
                Case when DBMaterialInfo.AutoID Is Not Null Then 1 Else 0 End As UpdatedFromDatabase
        From Data_Import_RJ.dbo.TestImport0000_MixInfo As MixInfo
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
                    IsNull(ComponentCategory.ItemCategory, '') As ComponentCategoryName, 
                    IsNull(ComponentCategory.[Description], '') As ComponentCategoryDescription,
                    IsNull(ComponentCategory.ShortDescription, '') As ComponentCategoryShortDescription,
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
        ) As DBMaterialInfo
        On MixInfo.MaterialItemCode = DBMaterialInfo.ItemCode
        Left Join
        (
        	Select -1 As AutoID, Plant.Name As PlantName, ItemName.Name As MaterialItemCode
        	From dbo.Plants As Plant
        	Inner Join dbo.MATERIAL As Material
        	On Material.PlantID = Plant.PlantId
        	Inner Join dbo.ItemMaster As ItemMaster
        	On ItemMaster.ItemMasterID = Material.ItemMasterID
        	Inner Join dbo.Name As ItemName
        	On ItemName.NameID = ItemMaster.NameID
        )  As ExistingMaterial
        On  MixInfo.PlantCode = ExistingMaterial.PlantName And
            MixInfo.MaterialItemCode = ExistingMaterial.MaterialItemCode
        Left Join Data_Import_RJ.dbo.TestImport0000_MaterialInfo As ExistingMaterialInfo
        On  MixInfo.PlantCode = ExistingMaterialInfo.PlantName And
            MixInfo.MaterialItemCode = ExistingMaterialInfo.ItemCode
        Where   Isnull(MixInfo.PlantCode, '') <> '' And
                Isnull(MixInfo.MaterialItemCode, '') <> '' And
                ExistingMaterial.AutoID Is Null And
                ExistingMaterialInfo.AutoID Is Null And
                MixInfo.AutoID In
                (
        	        Select Min(MixInfo.AutoID)
        	        From Data_Import_RJ.dbo.TestImport0000_MixInfo As MixInfo
        	        Group By MixInfo.MaterialItemCode, MixInfo.PlantCode
                )
        Order By MixInfo.MaterialItemCode, MixInfo.PlantCode
    End
End
Go
